const User = require('./User');
const Facility = require('./Facility');
const Position = require('./Position');
const Conversation = require('./Conversation');
const Message = require('./Message');

// Define associations
Position.belongsTo(Facility, {
  foreignKey: 'facilityId',
  as: 'facility'
});

Facility.hasMany(Position, {
  foreignKey: 'facilityId',
  as: 'positions'
});

// Chat associations
Conversation.belongsTo(User, { foreignKey: 'userId', as: 'user' });
Conversation.belongsTo(Facility, { foreignKey: 'facilityId', as: 'facility' });
User.hasMany(Conversation, { foreignKey: 'userId', as: 'conversations' });
Facility.hasMany(Conversation, { foreignKey: 'facilityId', as: 'conversations' });

Message.belongsTo(Conversation, { foreignKey: 'conversationId', as: 'conversation' });
Conversation.hasMany(Message, { foreignKey: 'conversationId', as: 'messages' });

module.exports = {
  User,
  Facility,
  Position,
  Conversation,
  Message
};
