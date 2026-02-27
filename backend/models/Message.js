const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Message = sequelize.define('Message', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  conversationId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'conversations',
      key: 'id'
    }
  },
  senderType: {
    type: DataTypes.ENUM('user', 'facility'),
    allowNull: false
  },
  senderId: {
    type: DataTypes.UUID,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  tableName: 'messages',
  timestamps: true
});

module.exports = Message;
