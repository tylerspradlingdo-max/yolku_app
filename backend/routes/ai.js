const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { Position, Facility } = require('../models');
const { Op } = require('sequelize');

// Valid profession values (mirrors the Position model ENUM)
const VALID_PROFESSIONS = ['RN', 'LPN', 'CNA', 'Doctor', 'PA', 'NP', 'Therapist', 'Pharmacist', 'Other'];

/**
 * Score a position against a user profile and return 0-100 match score
 * plus an array of human-readable match reasons.
 */
function scorePosition(position, profile) {
  let score = 0;
  const reasons = [];

  // Profession match (up to 60 points)
  if (position.profession === profile.profession) {
    score += 60;
    reasons.push(`Matches your profession (${profile.profession})`);
  } else {
    // Partial credit for related professions
    const related = {
      RN: ['LPN', 'NP'],
      LPN: ['RN', 'CNA'],
      CNA: ['LPN'],
      NP: ['RN', 'PA'],
      PA: ['NP', 'Doctor'],
      Doctor: ['PA', 'NP'],
      Therapist: [],
      Pharmacist: [],
      Other: []
    };
    if ((related[profile.profession] || []).includes(position.profession)) {
      score += 20;
      reasons.push(`Related profession (${position.profession})`);
    }
  }

  // State / location preference (up to 20 points)
  if (profile.preferredState && position.facility) {
    if (position.facility.state === profile.preferredState.toUpperCase()) {
      score += 20;
      reasons.push(`Located in your preferred state (${position.facility.state})`);
    }
  } else if (position.facility) {
    // No preference specified — give a base locality score
    score += 10;
    reasons.push(`Position available in ${position.facility.state}`);
  }

  // Salary expectation (up to 10 points)
  const salary = parseFloat(position.salary) || 0;
  const minSalary = parseFloat(profile.minSalary) || 0;
  if (salary > 0 && salary >= minSalary) {
    score += 10;
    reasons.push(`Salary meets your expectation ($${salary.toFixed(2)})`);
  } else if (salary > 0) {
    reasons.push(`Salary below expectation ($${salary.toFixed(2)})`);
  }

  // Near-term start date (up to 10 points)
  const startDate = position.startDate ? new Date(position.startDate) : null;
  const now = new Date();
  if (startDate) {
    const daysUntilStart = Math.ceil((startDate - now) / (1000 * 60 * 60 * 24));
    if (daysUntilStart >= 0 && daysUntilStart <= 30) {
      score += 10;
      reasons.push('Starts within 30 days');
    } else if (daysUntilStart > 30 && daysUntilStart <= 90) {
      score += 5;
      reasons.push('Starts within 90 days');
    }
  }

  return { score: Math.min(score, 100), reasons };
}

/**
 * POST /api/ai/match
 * AI-powered job matching: returns open positions ranked by how well they
 * fit the supplied user profile.
 *
 * Body params:
 *   profession      {string}  Required. User's profession type.
 *   preferredState  {string}  Optional. Two-letter state code (e.g. "CA").
 *   minSalary       {number}  Optional. Minimum acceptable salary.
 *   limit           {number}  Optional. Max results to return (default 20).
 */
router.post(
  '/match',
  [
    body('profession')
      .isIn(VALID_PROFESSIONS)
      .withMessage(`profession must be one of: ${VALID_PROFESSIONS.join(', ')}`),
    body('preferredState')
      .optional()
      .isLength({ min: 2, max: 2 })
      .isAlpha()
      .withMessage('preferredState must be a 2-letter state code'),
    body('minSalary')
      .optional()
      .isFloat({ min: 0 })
      .withMessage('minSalary must be a non-negative number'),
    body('limit')
      .optional()
      .isInt({ min: 1, max: 100 })
      .withMessage('limit must be an integer between 1 and 100')
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    try {
      const {
        profession,
        preferredState,
        minSalary,
        limit = 20
      } = req.body;

      const profile = { profession, preferredState, minSalary };

      // Fetch all open, active positions with their facility data
      const positions = await Position.findAll({
        where: { status: 'Open', isActive: true },
        include: [
          {
            model: Facility,
            as: 'facility',
            where: { isActive: true },
            attributes: ['id', 'name', 'address', 'city', 'state', 'zipCode', 'facilityType']
          }
        ]
      });

      // Score and sort positions
      const scored = positions
        .map((pos) => {
          const { score, reasons } = scorePosition(pos.toJSON(), profile);
          return { position: pos, score, matchReasons: reasons };
        })
        .filter((item) => item.score > 0)
        .sort((a, b) => b.score - a.score)
        .slice(0, parseInt(limit, 10));

      const matches = scored.map(({ position, score, matchReasons }) => ({
        ...position.toJSON(),
        matchScore: score,
        matchReasons
      }));

      res.json({
        success: true,
        profession,
        totalScanned: positions.length,
        matchCount: matches.length,
        data: matches
      });
    } catch (error) {
      console.error('AI match error:', error);
      res.status(500).json({
        success: false,
        error: { message: 'Failed to run AI matching', details: error.message }
      });
    }
  }
);

/**
 * GET /api/ai/professions
 * Returns the list of valid profession values the AI matcher understands.
 */
router.get('/professions', (req, res) => {
  res.json({ success: true, data: VALID_PROFESSIONS });
});

module.exports = router;
