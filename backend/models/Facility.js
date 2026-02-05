const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const bcrypt = require('bcryptjs');

const Facility = sequelize.define('Facility', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 200]
    }
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
      notEmpty: true
    }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [8, 100]
    }
  },
  address: {
    type: DataTypes.STRING,
    allowNull: false
  },
  city: {
    type: DataTypes.STRING,
    allowNull: false
  },
  state: {
    type: DataTypes.STRING(2),
    allowNull: false,
    validate: {
      len: [2, 2],
      isUppercase: true
    }
  },
  zipCode: {
    type: DataTypes.STRING,
    allowNull: false
  },
  phoneNumber: {
    type: DataTypes.STRING,
    allowNull: true
  },
  facilityType: {
    type: DataTypes.ENUM(
      'Hospital',
      'Clinic',
      'Nursing Home',
      'Assisted Living',
      'Home Health',
      'Urgent Care',
      'Rehabilitation Center',
      'Other'
    ),
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
}, {
  tableName: 'facilities',
  timestamps: true,
  hooks: {
    beforeCreate: async (facility) => {
      if (facility.password) {
        const salt = await bcrypt.genSalt(10);
        facility.password = await bcrypt.hash(facility.password, salt);
      }
    },
    beforeUpdate: async (facility) => {
      if (facility.changed('password')) {
        const salt = await bcrypt.genSalt(10);
        facility.password = await bcrypt.hash(facility.password, salt);
      }
    }
  }
});

// Instance method to compare passwords
Facility.prototype.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Instance method to get public profile (hide password)
Facility.prototype.toJSON = function() {
  const values = Object.assign({}, this.get());
  delete values.password;
  return values;
};

module.exports = Facility;
