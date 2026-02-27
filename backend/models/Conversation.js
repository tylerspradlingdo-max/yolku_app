const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Conversation = sequelize.define('Conversation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  facilityId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'facilities',
      key: 'id'
    }
  }
}, {
  tableName: 'conversations',
  timestamps: true,
  indexes: [
    {
      unique: true,
      fields: ['userId', 'facilityId']
    }
  ]
});

module.exports = Conversation;
