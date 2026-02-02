const sequelize = require('../config/database');
const { User, Facility, Position } = require('../models');

async function seedDatabase() {
  try {
    console.log('🌱 Seeding database with sample data...');

    // Test connection
    await sequelize.authenticate();
    console.log('✅ Database connection established');

    // Create sample facilities
    const facilities = await Facility.bulkCreate([
      {
        name: 'General Hospital',
        address: '123 Medical Center Dr',
        city: 'San Francisco',
        state: 'CA',
        zipCode: '94102',
        phoneNumber: '(415) 555-0100',
        facilityType: 'Hospital',
        description: 'A leading medical center providing comprehensive healthcare services'
      },
      {
        name: 'City Medical Center',
        address: '456 Healthcare Blvd',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90012',
        phoneNumber: '(323) 555-0200',
        facilityType: 'Hospital',
        description: 'State-of-the-art facility with modern equipment'
      },
      {
        name: 'Community Nursing Home',
        address: '789 Elder Care Way',
        city: 'Sacramento',
        state: 'CA',
        zipCode: '95814',
        phoneNumber: '(916) 555-0300',
        facilityType: 'Nursing Home',
        description: 'Compassionate care for elderly residents'
      },
      {
        name: 'NYC Healthcare Center',
        address: '321 Park Avenue',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        phoneNumber: '(212) 555-0400',
        facilityType: 'Hospital',
        description: 'Premier healthcare facility in Manhattan'
      },
      {
        name: 'Sunset Urgent Care',
        address: '555 Sunset Blvd',
        city: 'San Diego',
        state: 'CA',
        zipCode: '92101',
        phoneNumber: '(619) 555-0500',
        facilityType: 'Urgent Care',
        description: 'Fast and efficient urgent care services'
      },
      {
        name: 'Austin Medical Clinic',
        address: '777 Main Street',
        city: 'Austin',
        state: 'TX',
        zipCode: '78701',
        phoneNumber: '(512) 555-0600',
        facilityType: 'Clinic',
        description: 'Community clinic serving Austin area'
      }
    ]);

    console.log(`✅ Created ${facilities.length} facilities`);

    // Create sample positions
    const positions = [];
    const today = new Date();
    
    // Create positions for the next 30 days
    for (let i = 0; i < 30; i++) {
      const shiftDate = new Date(today);
      shiftDate.setDate(today.getDate() + i);
      const dateStr = shiftDate.toISOString().split('T')[0];
      
      // Add multiple positions per day across different facilities
      if (i % 3 === 0) {
        positions.push({
          facilityId: facilities[0].id,
          title: 'Registered Nurse - Night Shift',
          profession: 'RN',
          description: 'Looking for experienced RN for night shift coverage',
          requirements: 'Valid RN license, 2+ years experience preferred',
          shiftDate: dateStr,
          shiftStartTime: '19:00:00',
          shiftEndTime: '07:00:00',
          hourlyRate: 65.00,
          openings: 2,
          status: 'Open'
        });
      }
      
      if (i % 4 === 0) {
        positions.push({
          facilityId: facilities[1].id,
          title: 'Licensed Practical Nurse - Day Shift',
          profession: 'LPN',
          description: 'Day shift LPN needed for medical-surgical unit',
          requirements: 'Valid LPN license, excellent patient care skills',
          shiftDate: dateStr,
          shiftStartTime: '07:00:00',
          shiftEndTime: '15:00:00',
          hourlyRate: 45.00,
          openings: 1,
          status: 'Open'
        });
      }
      
      if (i % 2 === 0) {
        positions.push({
          facilityId: facilities[2].id,
          title: 'Certified Nursing Assistant',
          profession: 'CNA',
          description: 'CNA needed for elderly care facility',
          requirements: 'Valid CNA certification, compassionate care',
          shiftDate: dateStr,
          shiftStartTime: '11:00:00',
          shiftEndTime: '19:00:00',
          hourlyRate: 28.00,
          openings: 3,
          status: 'Open'
        });
      }
      
      if (i % 5 === 0) {
        positions.push({
          facilityId: facilities[3].id,
          title: 'Nurse Practitioner',
          profession: 'NP',
          description: 'NP needed for outpatient clinic',
          requirements: 'Valid NP license, primary care experience',
          shiftDate: dateStr,
          shiftStartTime: '08:00:00',
          shiftEndTime: '17:00:00',
          hourlyRate: 85.00,
          openings: 1,
          status: 'Open'
        });
      }
      
      if (i % 6 === 0) {
        positions.push({
          facilityId: facilities[4].id,
          title: 'Physician Assistant - Urgent Care',
          profession: 'PA',
          description: 'PA for urgent care facility, flexible schedule',
          requirements: 'Valid PA license, ER or urgent care experience preferred',
          shiftDate: dateStr,
          shiftStartTime: '12:00:00',
          shiftEndTime: '20:00:00',
          hourlyRate: 75.00,
          openings: 1,
          status: 'Open'
        });
      }
      
      if (i % 7 === 0) {
        positions.push({
          facilityId: facilities[5].id,
          title: 'Physical Therapist',
          profession: 'Therapist',
          description: 'PT needed for rehabilitation services',
          requirements: 'Valid PT license, orthopedic experience',
          shiftDate: dateStr,
          shiftStartTime: '09:00:00',
          shiftEndTime: '17:00:00',
          hourlyRate: 70.00,
          openings: 1,
          status: 'Open'
        });
      }
    }

    await Position.bulkCreate(positions);
    console.log(`✅ Created ${positions.length} positions`);

    console.log('🎉 Database seeding complete!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Database seeding failed:', error);
    process.exit(1);
  }
}

seedDatabase();
