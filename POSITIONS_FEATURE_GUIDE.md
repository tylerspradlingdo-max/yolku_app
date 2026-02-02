# Find Available Positions Feature - Testing Guide

## Overview
This feature allows healthcare workers to browse available positions from healthcare facilities with filters for state and date range.

## Backend Implementation

### Database Models
1. **Facility Model** (`backend/models/Facility.js`)
   - Stores healthcare facility information
   - Fields: name, address, city, state, zipCode, facilityType, etc.

2. **Position Model** (`backend/models/Position.js`)
   - Stores available shift positions
   - Fields: title, profession, shiftDate, shiftStartTime, shiftEndTime, hourlyRate, openings, status
   - Associated with Facility via facilityId

### API Endpoints
- `GET /api/positions` - List all available positions
  - Query params: `state`, `startDate`, `endDate`, `profession`
  - Example: `/api/positions?state=CA&startDate=2026-02-01&endDate=2026-02-28`
  
- `GET /api/positions/:id` - Get specific position details
  
- `GET /api/positions/states/list` - Get list of states with available positions

### Database Setup
```bash
cd backend

# Initialize database tables
npm run db:init

# Seed with sample data (creates facilities and ~100+ positions)
npm run db:seed
```

## iOS App Implementation

### Features
1. **Positions Listing** (`YolkuApp/YolkuApp/ShiftsView.swift`)
   - Displays available positions in scrollable list
   - Shows facility name, location, position title, date/time, hourly rate
   - Search functionality for facilities and locations
   - Loading and error states

2. **State Filter**
   - Tap "All States" button to filter by state
   - Lists all states that have available positions
   - Clear filter with X button

3. **Date Range Filter**
   - Tap "Date Range" button to set start/end dates
   - Toggle start date and/or end date filtering
   - Clear filter with X button

4. **Navigation**
   - "Find Available Positions" button on home dashboard navigates to positions tab
   - Tab bar navigation to quickly access positions

### Mock Mode
The iOS app currently runs in **mock mode** (APIConfig.useMockMode = true), which generates sample data without requiring a backend server. This allows testing the UI and filters without database setup.

To connect to real API:
1. Open `YolkuApp/YolkuApp/APIConfig.swift`
2. Set `useMockMode = false`
3. Ensure backend server is running
4. Update `developmentURL` or `productionURL` as needed

## Testing the Feature

### Backend Testing (with database)
1. Set up PostgreSQL database
2. Configure `.env` file with database credentials
3. Run `npm run db:init` to create tables
4. Run `npm run db:seed` to populate sample data
5. Start server: `npm start`
6. Test endpoints with curl or Postman:
   ```bash
   # List all positions
   curl http://localhost:3000/api/positions
   
   # Filter by state
   curl http://localhost:3000/api/positions?state=CA
   
   # Filter by date range
   curl "http://localhost:3000/api/positions?startDate=2026-02-01&endDate=2026-02-28"
   
   # Get available states
   curl http://localhost:3000/api/positions/states/list
   ```

### iOS Testing (mock mode)
1. Open project in Xcode
2. Build and run on simulator or device
3. Sign in or create account
4. Tap "Find Available Positions" on home screen
5. Verify:
   - Position cards display with facility info, dates, rates
   - State filter shows and filters positions
   - Date range filter works
   - Search filters results
   - "Apply Now" button is present on each card

### Integration Testing (iOS + Backend)
1. Ensure backend is running with seeded data
2. In Xcode, open `APIConfig.swift`
3. Set `useMockMode = false`
4. Update `developmentURL` to point to your backend
5. Rebuild and run iOS app
6. Test all filters with real data from backend

## Filter Examples

### State Filter
- Select "CA" - shows only California positions
- Select "NY" - shows only New York positions
- Select "All States" - shows positions from all states

### Date Range Filter
- Start date only: Shows positions on or after that date
- End date only: Shows positions on or before that date
- Both dates: Shows positions within the date range

### Search
- Type facility name: "General Hospital"
- Type city: "San Francisco"
- Type position: "Nurse"

## Expected Results

### Sample Data (from seed script)
- 6 facilities across CA, NY, TX
- ~100+ positions over next 30 days
- Various professions: RN, LPN, CNA, NP, PA, Therapist
- Hourly rates ranging from $28-$85/hr
- Multiple shift times: day, evening, night

### UI Behavior
- Loading spinner while fetching data
- Error message with retry button if fetch fails
- Empty state message if no positions match filters
- Position cards sorted by date (earliest first)
- Smooth filter interactions with immediate updates

## Notes
- Mock mode generates random positions on each load
- Real API mode caches positions until filters change
- All dates are in YYYY-MM-DD format
- Times are in 24-hour format (HH:mm:ss)
- Positions are filtered on backend for efficiency
