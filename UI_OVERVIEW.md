# Find Available Positions Feature - UI Overview

## Feature Summary
This document describes the UI implementation for the "Find Available Positions" feature that allows healthcare workers to browse and filter available positions from healthcare facilities.

## Navigation Flow

### 1. Home Dashboard (After Login)
- Location: `YolkuApp/YolkuApp/DashboardView.swift` → `HomeTabView`
- Quick Action button: **"Find Available Positions"**
  - Icon: Magnifying glass
  - Subtitle: "Browse healthcare facilities near you"
  - Action: **Navigates to Positions tab** (tab index 1)

### 2. Positions Listing Screen
- Location: `YolkuApp/YolkuApp/ShiftsView.swift`
- Tab bar label: "Find Positions"
- Navigation title: "Find Positions"

## UI Components

### Search Bar
- Text field with magnifying glass icon
- Placeholder: "Search facilities or locations"
- Clear button (X) appears when text is entered
- Filters positions by facility name, city, or position title

### Filter Chips (Horizontal scroll)
1. **State Filter**
   - Icon: Map icon
   - Text: "All States" or selected state (e.g., "CA")
   - Tap to open state selection sheet
   - Shows X icon when filter is active
   - Active state: Gradient background (purple to blue)
   - Inactive state: White background with blue border

2. **Date Range Filter**
   - Icon: Calendar icon
   - Text: "Date Range" or formatted range (e.g., "Feb 1 - Feb 28")
   - Tap to open date picker sheet
   - Shows X icon when filter is active
   - Active state: Gradient background (purple to blue)
   - Inactive state: White background with blue border

3. **Clear All Button**
   - Only appears when filters are active
   - Red text and border
   - Clears all active filters at once

### Position Cards
Each card displays:
- **Header Row**:
  - Facility name (bold, large text)
  - Location (city, state) with map pin icon
  - Hourly rate (bold, purple, right-aligned) - e.g., "$65/hr"

- **Divider line**

- **Position Details Row**:
  - Position title (e.g., "Registered Nurse - Night Shift")
  - Shift date (formatted: "Feb 15, 2026")
  - Shift time (formatted: "7:00 PM - 7:00 AM")

- **Openings Badge** (if multiple openings):
  - Icon: Two people icon
  - Text: "2 openings available"

- **Apply Button**:
  - Full-width gradient button
  - Text: "Apply Now"
  - Purple to pink gradient

### Loading State
- Centered progress spinner
- Displayed while fetching positions from API

### Error State
- Warning icon (triangle with exclamation mark)
- Title: "Error Loading Positions"
- Error message text
- "Retry" button with gradient background

### Empty State
- Calendar with plus icon (large, faded purple)
- Title: "No Positions Available"
- Message: "Check back soon for available positions from healthcare facilities near you"
- "Refresh" button with gradient background

## Filter Sheets (Modal Presentations)

### State Filter Sheet
- Full-screen modal
- Navigation title: "Filter by State"
- List of options:
  - "All States" (selected by default)
  - Individual states (CA, NY, TX, etc.)
  - Checkmark indicates current selection
- "Done" button in top-right corner
- Selecting a state applies filter immediately and closes sheet

### Date Range Filter Sheet
- Full-screen modal
- Navigation title: "Date Range"
- Form sections:
  1. **Start Date Section**:
     - Toggle: "Filter by start date"
     - Date picker (appears when toggle is ON)
     - Label: "From"
  
  2. **End Date Section**:
     - Toggle: "Filter by end date"
     - Date picker (appears when toggle is ON)
     - Label: "Until"

- Navigation buttons:
  - "Cancel" (top-left) - closes without applying
  - "Apply" (top-right) - applies filters and closes

## Color Scheme
- **Primary Gradient**: Purple (#667eea) to Pink (#764ba2)
- **Background**: Light gray (#f5f5f5)
- **Cards**: White with subtle shadow
- **Text Primary**: Dark gray (#333333)
- **Text Secondary**: Medium gray
- **Active Filter**: Gradient background, white text
- **Inactive Filter**: White background, purple border, purple text

## Interaction Behavior

### Filter Application
1. User taps filter button
2. Sheet modal appears
3. User makes selection
4. Filter applies immediately (state) or on "Apply" button (date range)
5. Sheet closes
6. Position list refreshes with filtered results
7. Filter button updates to show active state

### Search
- Updates results in real-time as user types
- Case-insensitive matching
- Searches across facility name, city, and position title

### Data Loading
1. Screen appears → Shows loading spinner
2. API call completes → Updates position list
3. If error → Shows error state with retry button
4. If no results → Shows empty state with refresh button

### Refresh
- Tap refresh/retry button → Re-fetch positions from API
- Filter changes → Automatically refresh with new filters

## Mock Data Features
In mock mode (default), the app generates:
- 20 random positions
- 6 different facilities
- Locations in CA, NY, TX
- Various professions (RN, LPN, CNA, NP, PA, Therapist)
- Dates spread over next 30 days
- Hourly rates between $25-$85
- 1-3 openings per position

## Code Structure

### API Service (`APIService.swift`)
```swift
// Fetch positions with filters
func getPositions(state: String?, startDate: String?, endDate: String?, profession: String?) async throws -> [Position]

// Get list of available states
func getAvailableStates() async throws -> [String]
```

### Data Models (`APIService.swift`)
```swift
struct Position: Codable, Identifiable {
    let id: String
    let facility: Facility
    let title: String
    let profession: String
    let shiftDate: String
    let shiftStartTime: String
    let shiftEndTime: String
    let hourlyRate: Double
    let openings: Int
}

struct Facility: Codable {
    let id: String
    let name: String
    let city: String
    let state: String
    let facilityType: String
}
```

### View Components
- `ShiftsView` - Main positions listing
- `ShiftCard` - Individual position card
- `StateFilterSheet` - State selection modal
- `DateRangeFilterSheet` - Date range picker modal

## Accessibility
- All buttons have proper tap targets
- Text fields have clear labels
- Loading states provide feedback
- Error messages are clear and actionable

## Future Enhancements (Not in Current Implementation)
- Map view of facility locations
- Save favorite facilities
- Application history
- Push notifications for new positions
- Filter by profession/specialty
- Distance-based filtering
- Shift calendar view
