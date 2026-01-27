const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Generate JWT token
const generateToken = (userId) => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET || 'your_jwt_secret_key',
    { expiresIn: process.env.JWT_EXPIRE || '7d' }
  );
};

/**
 * @route   POST /api/auth/signup
 * @desc    Register a new healthcare worker
 * @access  Public
 */
router.post('/signup',
  [
    body('firstName').trim().isLength({ min: 2, max: 50 }).withMessage('First name must be 2-50 characters'),
    body('lastName').trim().isLength({ min: 2, max: 50 }).withMessage('Last name must be 2-50 characters'),
    body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
    body('phoneNumber').optional().matches(/^[\d\s\-\+\(\)]+$/).withMessage('Invalid phone number format'),
    body('profession').isIn(['RN', 'LPN', 'CNA', 'Doctor', 'PA', 'NP', 'Therapist', 'Pharmacist', 'Other']).withMessage('Valid profession is required'),
    body('licenseNumber').optional().trim()
  ],
  async (req, res) => {
    try {
      // Validate input
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { firstName, lastName, email, password, phoneNumber, profession, licenseNumber } = req.body;

      // Check if user already exists
      const existingUser = await User.findOne({ where: { email } });
      if (existingUser) {
        return res.status(409).json({ error: 'Email already registered' });
      }

      // Create new user
      const user = await User.create({
        firstName,
        lastName,
        email,
        password,
        phoneNumber,
        profession,
        licenseNumber
      });

      // Generate token
      const token = generateToken(user.id);

      res.status(201).json({
        message: 'User registered successfully',
        token,
        user: user.toJSON()
      });
    } catch (error) {
      console.error('Signup error:', error);
      res.status(500).json({ error: 'Failed to register user' });
    }
  }
);

/**
 * @route   POST /api/auth/signin
 * @desc    Sign in a user
 * @access  Public
 */
router.post('/signin',
  [
    body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
    body('password').notEmpty().withMessage('Password is required')
  ],
  async (req, res) => {
    try {
      // Validate input
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { email, password } = req.body;

      // Find user
      const user = await User.findOne({ where: { email } });
      if (!user) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }

      // Check if user is active
      if (!user.isActive) {
        return res.status(403).json({ error: 'Account is deactivated' });
      }

      // Verify password
      const isPasswordValid = await user.comparePassword(password);
      if (!isPasswordValid) {
        return res.status(401).json({ error: 'Invalid email or password' });
      }

      // Update last login
      user.lastLogin = new Date();
      await user.save();

      // Generate token
      const token = generateToken(user.id);

      res.json({
        message: 'Signed in successfully',
        token,
        user: user.toJSON()
      });
    } catch (error) {
      console.error('Signin error:', error);
      res.status(500).json({ error: 'Failed to sign in' });
    }
  }
);

/**
 * @route   POST /api/auth/verify
 * @desc    Verify JWT token
 * @access  Public
 */
router.post('/verify', async (req, res) => {
  try {
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ error: 'Token is required' });
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your_jwt_secret_key');
    
    // Find user
    const user = await User.findByPk(decoded.userId);
    if (!user || !user.isActive) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    res.json({
      valid: true,
      user: user.toJSON()
    });
  } catch (error) {
    console.error('Token verification error:', error);
    res.status(401).json({ error: 'Invalid or expired token' });
  }
});

module.exports = router;
