const express = require('express');
const router = express.Router();
const { Facility, Position } = require('../models');
const { Op } = require('sequelize');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');

/**
 * Middleware to verify facility JWT token
 */
const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false,
        error: 'No token provided' 
      });
    }

    const token = authHeader.substring(7);
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your_jwt_secret_key');
    
    // Verify this is a facility token
    if (decoded.type !== 'facility') {
      return res.status(403).json({ 
        success: false,
        error: 'Invalid token type' 
      });
    }
    
    req.facilityId = decoded.facilityId;
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    return res.status(401).json({ 
      success: false,
      error: 'Invalid or expired token' 
    });
  }
};

/**
 * POST /api/facilities/signup
 * Register a new facility
 */
router.post('/signup', [
  body('name').trim().isLength({ min: 2, max: 200 }).withMessage('Name must be between 2 and 200 characters'),
  body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  body('address').trim().notEmpty().withMessage('Address is required'),
  body('city').trim().notEmpty().withMessage('City is required'),
  body('state').trim().isLength({ min: 2, max: 2 }).toUpperCase().withMessage('Valid 2-letter state code required'),
  body('zipCode').trim().notEmpty().withMessage('Zip code is required'),
  body('facilityType').isIn(['Hospital', 'Clinic', 'Nursing Home', 'Assisted Living', 'Home Health', 'Urgent Care', 'Rehabilitation Center', 'Other']).withMessage('Valid facility type required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }

    const { name, email, password, address, city, state, zipCode, phoneNumber, facilityType, description } = req.body;

    // Check if facility already exists
    const existingFacility = await Facility.findOne({ where: { email } });
    if (existingFacility) {
      return res.status(400).json({ 
        success: false,
        error: 'Facility with this email already exists' 
      });
    }

    // Create facility
    const facility = await Facility.create({
      name,
      email,
      password,
      address,
      city,
      state: state.toUpperCase(),
      zipCode,
      phoneNumber,
      facilityType,
      description
    });

    // Generate JWT token
    const token = jwt.sign(
      { facilityId: facility.id, type: 'facility' },
      process.env.JWT_SECRET || 'your_jwt_secret_key',
      { expiresIn: '30d' }
    );

    res.status(201).json({
      success: true,
      message: 'Facility registered successfully',
      data: {
        facility,
        token
      }
    });
  } catch (error) {
    console.error('Facility signup error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to register facility',
        details: error.message
      }
    });
  }
});

/**
 * POST /api/facilities/signin
 * Facility login
 */
router.post('/signin', [
  body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }

    const { email, password } = req.body;

    // Find facility
    const facility = await Facility.findOne({ where: { email } });
    if (!facility) {
      return res.status(401).json({ 
        success: false,
        error: 'Invalid email or password' 
      });
    }

    // Check if facility is active
    if (!facility.isActive) {
      return res.status(403).json({ 
        success: false,
        error: 'Facility account is inactive' 
      });
    }

    // Verify password
    const isValidPassword = await facility.comparePassword(password);
    if (!isValidPassword) {
      return res.status(401).json({ 
        success: false,
        error: 'Invalid email or password' 
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      { facilityId: facility.id, type: 'facility' },
      process.env.JWT_SECRET || 'your_jwt_secret_key',
      { expiresIn: '30d' }
    );

    res.json({
      success: true,
      message: 'Signed in successfully',
      data: {
        facility,
        token
      }
    });
  } catch (error) {
    console.error('Facility signin error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to sign in',
        details: error.message
      }
    });
  }
});

/**
 * GET /api/facilities/profile
 * Get facility profile
 */
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const facility = await Facility.findByPk(req.facilityId);
    
    if (!facility) {
      return res.status(404).json({
        success: false,
        error: 'Facility not found'
      });
    }

    res.json({
      success: true,
      data: facility
    });
  } catch (error) {
    console.error('Get facility profile error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to fetch profile',
        details: error.message
      }
    });
  }
});

/**
 * PUT /api/facilities/profile
 * Update facility profile
 */
router.put('/profile', authMiddleware, [
  body('name').optional().trim().isLength({ min: 2, max: 200 }),
  body('address').optional().trim().notEmpty(),
  body('city').optional().trim().notEmpty(),
  body('state').optional().trim().isLength({ min: 2, max: 2 }).toUpperCase(),
  body('zipCode').optional().trim().notEmpty(),
  body('phoneNumber').optional().trim(),
  body('facilityType').optional().isIn(['Hospital', 'Clinic', 'Nursing Home', 'Assisted Living', 'Home Health', 'Urgent Care', 'Rehabilitation Center', 'Other']),
  body('description').optional().trim()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }

    const facility = await Facility.findByPk(req.facilityId);
    
    if (!facility) {
      return res.status(404).json({
        success: false,
        error: 'Facility not found'
      });
    }

    // Update allowed fields
    const { name, address, city, state, zipCode, phoneNumber, facilityType, description } = req.body;
    const updates = {};
    
    if (name) updates.name = name;
    if (address) updates.address = address;
    if (city) updates.city = city;
    if (state) updates.state = state.toUpperCase();
    if (zipCode) updates.zipCode = zipCode;
    if (phoneNumber !== undefined) updates.phoneNumber = phoneNumber;
    if (facilityType) updates.facilityType = facilityType;
    if (description !== undefined) updates.description = description;

    await facility.update(updates);

    res.json({
      success: true,
      message: 'Profile updated successfully',
      data: facility
    });
  } catch (error) {
    console.error('Update facility profile error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to update profile',
        details: error.message
      }
    });
  }
});

/**
 * GET /api/facilities/positions
 * Get all positions for the authenticated facility
 */
router.get('/positions', authMiddleware, async (req, res) => {
  try {
    const positions = await Position.findAll({
      where: { facilityId: req.facilityId },
      order: [['startDate', 'ASC'], ['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      count: positions.length,
      data: positions
    });
  } catch (error) {
    console.error('Get facility positions error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to fetch positions',
        details: error.message
      }
    });
  }
});

/**
 * POST /api/facilities/positions
 * Create a new position for the authenticated facility
 */
router.post('/positions', authMiddleware, [
  body('title').trim().notEmpty().withMessage('Title is required'),
  body('profession').isIn(['RN', 'LPN', 'CNA', 'Doctor', 'PA', 'NP', 'Therapist', 'Pharmacist', 'Other']).withMessage('Valid profession required'),
  body('startDate').isISO8601().toDate().withMessage('Valid start date required'),
  body('endDate').optional({ nullable: true }).isISO8601().toDate().withMessage('Valid end date required'),
  body('salary').isFloat({ min: 0 }).withMessage('Valid salary required'),
  body('location').optional().trim(),
  body('description').optional().trim(),
  body('requirements').optional().trim(),
  body('openings').optional().isInt({ min: 1 }).withMessage('Openings must be at least 1')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }

    const { title, profession, description, requirements, startDate, endDate, salary, location, openings } = req.body;

    const position = await Position.create({
      facilityId: req.facilityId,
      title,
      profession,
      description,
      requirements,
      startDate,
      endDate,
      salary,
      location,
      openings: openings || 1,
      status: 'Open'
    });

    res.status(201).json({
      success: true,
      message: 'Position created successfully',
      data: position
    });
  } catch (error) {
    console.error('Create position error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to create position',
        details: error.message
      }
    });
  }
});

/**
 * GET /api/facilities/positions/:id
 * Get a specific position for the authenticated facility
 */
router.get('/positions/:id', authMiddleware, async (req, res) => {
  try {
    const position = await Position.findOne({
      where: { 
        id: req.params.id,
        facilityId: req.facilityId 
      }
    });

    if (!position) {
      return res.status(404).json({
        success: false,
        error: 'Position not found'
      });
    }

    res.json({
      success: true,
      data: position
    });
  } catch (error) {
    console.error('Get position error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to fetch position',
        details: error.message
      }
    });
  }
});

/**
 * PUT /api/facilities/positions/:id
 * Update a position for the authenticated facility
 */
router.put('/positions/:id', authMiddleware, [
  body('title').optional().trim().notEmpty(),
  body('profession').optional().isIn(['RN', 'LPN', 'CNA', 'Doctor', 'PA', 'NP', 'Therapist', 'Pharmacist', 'Other']),
  body('startDate').optional().isISO8601().toDate(),
  body('endDate').optional({ nullable: true }).isISO8601().toDate(),
  body('salary').optional().isFloat({ min: 0 }),
  body('location').optional().trim(),
  body('description').optional().trim(),
  body('requirements').optional().trim(),
  body('openings').optional().isInt({ min: 1 }),
  body('status').optional().isIn(['Open', 'Filled', 'Cancelled'])
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false,
        errors: errors.array() 
      });
    }

    const position = await Position.findOne({
      where: { 
        id: req.params.id,
        facilityId: req.facilityId 
      }
    });

    if (!position) {
      return res.status(404).json({
        success: false,
        error: 'Position not found'
      });
    }

    // Update allowed fields
    const { title, profession, description, requirements, startDate, endDate, salary, location, openings, status } = req.body;
    const updates = {};
    
    if (title) updates.title = title;
    if (profession) updates.profession = profession;
    if (description !== undefined) updates.description = description;
    if (requirements !== undefined) updates.requirements = requirements;
    if (startDate) updates.startDate = startDate;
    if (endDate !== undefined) updates.endDate = endDate;
    if (salary) updates.salary = salary;
    if (location !== undefined) updates.location = location;
    if (openings) updates.openings = openings;
    if (status) updates.status = status;

    await position.update(updates);

    res.json({
      success: true,
      message: 'Position updated successfully',
      data: position
    });
  } catch (error) {
    console.error('Update position error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to update position',
        details: error.message
      }
    });
  }
});

/**
 * DELETE /api/facilities/positions/:id
 * Delete a position for the authenticated facility
 */
router.delete('/positions/:id', authMiddleware, async (req, res) => {
  try {
    const position = await Position.findOne({
      where: { 
        id: req.params.id,
        facilityId: req.facilityId 
      }
    });

    if (!position) {
      return res.status(404).json({
        success: false,
        error: 'Position not found'
      });
    }

    await position.destroy();

    res.json({
      success: true,
      message: 'Position deleted successfully'
    });
  } catch (error) {
    console.error('Delete position error:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to delete position',
        details: error.message
      }
    });
  }
});

module.exports = router;
