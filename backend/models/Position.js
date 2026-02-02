const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Position = sequelize.define('Position', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  facilityId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'facilities',
      key: 'id'
    }
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  profession: {
    type: DataTypes.ENUM(
      'RN',
      'LPN',
      'CNA',
      'Doctor',
      'PA',
      'NP',
      'Therapist',
      'Pharmacist',
      'Other'
    ),
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  requirements: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  shiftDate: {
    type: DataTypes.DATEONLY,
    allowNull: false
  },
  shiftStartTime: {
    type: DataTypes.TIME,
    allowNull: false
  },
  shiftEndTime: {
    type: DataTypes.TIME,
    allowNull: false
  },
  hourlyRate: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
    validate: {
      min: 0
    }
  },
  openings: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 1,
    validate: {
      min: 1
    }
  },
  status: {
    type: DataTypes.ENUM('Open', 'Filled', 'Cancelled'),
    allowNull: false,
    defaultValue: 'Open'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
}, {
  tableName: 'positions',
  timestamps: true,
  indexes: [
    {
      fields: ['facilityId']
    },
    {
      fields: ['shiftDate']
    },
    {
      fields: ['profession']
    },
    {
      fields: ['status']
    }
  ]
});

module.exports = Position;
