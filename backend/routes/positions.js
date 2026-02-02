const express = require('express');
const router = express.Router();
const { Position, Facility } = require('../models');
const { Op } = require('sequelize');

/**
 * GET /api/positions
 * Get all available positions with optional filters
 * Query params:
 * - state: Filter by facility state (e.g., "CA", "NY")
 * - startDate: Filter positions on or after this date (YYYY-MM-DD)
 * - endDate: Filter positions on or before this date (YYYY-MM-DD)
 * - profession: Filter by profession type
 */
router.get('/', async (req, res) => {
  try {
    const { state, startDate, endDate, profession } = req.query;
    
    // Build where clauses
    const positionWhere = {
      status: 'Open',
      isActive: true
    };
    
    const facilityWhere = {
      isActive: true
    };
    
    // Apply date filters
    if (startDate || endDate) {
      positionWhere.shiftDate = {};
      if (startDate) {
        positionWhere.shiftDate[Op.gte] = startDate;
      }
      if (endDate) {
        positionWhere.shiftDate[Op.lte] = endDate;
      }
    }
    
    // Apply profession filter
    if (profession) {
      positionWhere.profession = profession;
    }
    
    // Apply state filter
    if (state) {
      facilityWhere.state = state.toUpperCase();
    }
    
    // Query positions with facility data
    const positions = await Position.findAll({
      where: positionWhere,
      include: [{
        model: Facility,
        as: 'facility',
        where: facilityWhere,
        attributes: ['id', 'name', 'address', 'city', 'state', 'zipCode', 'facilityType']
      }],
      order: [
        ['shiftDate', 'ASC'],
        ['shiftStartTime', 'ASC']
      ]
    });
    
    res.json({
      success: true,
      count: positions.length,
      data: positions
    });
  } catch (error) {
    console.error('Error fetching positions:', error);
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
 * GET /api/positions/:id
 * Get a specific position by ID
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const position = await Position.findByPk(id, {
      include: [{
        model: Facility,
        as: 'facility',
        attributes: ['id', 'name', 'address', 'city', 'state', 'zipCode', 'phoneNumber', 'facilityType', 'description']
      }]
    });
    
    if (!position) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Position not found'
        }
      });
    }
    
    res.json({
      success: true,
      data: position
    });
  } catch (error) {
    console.error('Error fetching position:', error);
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
 * GET /api/positions/states/list
 * Get list of unique states that have available positions
 */
router.get('/states/list', async (req, res) => {
  try {
    const facilities = await Facility.findAll({
      attributes: ['state'],
      include: [{
        model: Position,
        as: 'positions',
        where: {
          status: 'Open',
          isActive: true
        },
        attributes: []
      }],
      group: ['Facility.state'],
      raw: true
    });
    
    const states = facilities.map(f => f.state).sort();
    
    res.json({
      success: true,
      data: states
    });
  } catch (error) {
    console.error('Error fetching states:', error);
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to fetch states',
        details: error.message
      }
    });
  }
});

module.exports = router;
