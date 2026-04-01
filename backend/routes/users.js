const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const User = require('../models/User');

/**
 * @route   GET /api/users/profile
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findByPk(req.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user: user.toJSON() });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Failed to get profile' });
  }
});

/**
 * @route   PUT /api/users/profile
 * @desc    Update current user profile
 * @access  Private
 */
router.put('/profile', authMiddleware, async (req, res) => {
  try {
    const { firstName, lastName, phoneNumber, profession, licenseNumber } = req.body;

    const user = await User.findByPk(req.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Update user fields
    if (firstName) user.firstName = firstName;
    if (lastName) user.lastName = lastName;
    if (phoneNumber !== undefined) user.phoneNumber = phoneNumber;
    if (profession) user.profession = profession;
    if (licenseNumber !== undefined) user.licenseNumber = licenseNumber;

    await user.save();

    res.json({
      message: 'Profile updated successfully',
      user: user.toJSON()
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

/**
 * @route   PATCH /api/users/profile
 * @desc    Update current user profile (including extended fields)
 * @access  Private
 */
router.patch('/profile', authMiddleware, async (req, res) => {
  try {
    const {
      firstName, lastName, phoneNumber, profession, licenseNumber,
      address, credentials, stateLicenses, boardCertifications
    } = req.body;

    const user = await User.findByPk(req.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (firstName) user.firstName = firstName;
    if (lastName) user.lastName = lastName;
    if (phoneNumber !== undefined) user.phoneNumber = phoneNumber;
    if (profession) user.profession = profession;
    if (licenseNumber !== undefined) user.licenseNumber = licenseNumber;
    if (address !== undefined) user.address = address;
    if (credentials !== undefined) user.credentials = credentials;
    if (stateLicenses !== undefined) user.stateLicenses = stateLicenses;
    if (boardCertifications !== undefined) user.boardCertifications = boardCertifications;

    await user.save();

    res.json({
      message: 'Profile updated successfully',
      user: user.toJSON()
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

module.exports = router;
