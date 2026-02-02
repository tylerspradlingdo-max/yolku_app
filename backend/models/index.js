const User = require('./User');
const Facility = require('./Facility');
const Position = require('./Position');

// Define associations
Position.belongsTo(Facility, {
  foreignKey: 'facilityId',
  as: 'facility'
});

Facility.hasMany(Position, {
  foreignKey: 'facilityId',
  as: 'positions'
});

module.exports = {
  User,
  Facility,
  Position
};
