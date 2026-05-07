const express = require('express');
const router = express.Router();
const housingListings = require('../data/housing-listings');

/**
 * GET /api/housing
 * Public housing listings with optional filters
 * Query params:
 * - city: exact city match (case-insensitive)
 * - state: 2-letter state code
 * - type: Studio | 1 Bedroom | 2 Bedroom | Shared Room | House
 * - furnished: true | false
 * - available: true | false
 */
router.get('/', (req, res) => {
  try {
    const { city, state, type, furnished, available } = req.query;

    const filtered = housingListings.filter((listing) => {
      const cityMatch =
        !city || listing.city.toLowerCase() === String(city).trim().toLowerCase();
      const stateMatch =
        !state || listing.state.toUpperCase() === String(state).trim().toUpperCase();
      const typeMatch =
        !type || listing.type.toLowerCase() === String(type).trim().toLowerCase();

      const furnishedFilter =
        furnished === undefined
          ? true
          : listing.isFurnished === (String(furnished).toLowerCase() === 'true');

      const availableFilter =
        available === undefined
          ? true
          : listing.isAvailable === (String(available).toLowerCase() === 'true');

      return cityMatch && stateMatch && typeMatch && furnishedFilter && availableFilter;
    });

    res.json({
      success: true,
      count: filtered.length,
      data: filtered
    });
  } catch (error) {
    console.error('Error fetching housing listings:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to fetch housing listings',
        details: error.message
      }
    });
  }
});

module.exports = router;
