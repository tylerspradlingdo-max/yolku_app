# Testing Yolku App Without Server Connection

## Problem

When testing the iOS app in the simulator, you might not be able to connect to the backend server because:

- ❌ Backend server is not running
- ❌ No internet connection
- ❌ Localhost not accessible from simulator
- ❌ Heroku server is down
- ❌ Network firewall blocking connections
- ❌ Just want to test UI without backend

## Solution: Mock Mode

The app now includes a **Mock Mode** that simulates API responses without requiring a server connection. This allows you to:

✅ Test the complete sign up flow  
✅ Test the sign in flow  
✅ Test navigation to dashboard  
✅ Test all UI components  
✅ Develop features offline  
✅ Demo the app without deployment  

---

## How to Enable Mock Mode

### Option 1: Quick Toggle (Recommended)

1. **Open APIConfig.swift**
   ```bash
   YolkuApp/YolkuApp/APIConfig.swift
   ```

2. **Find this line near the top:**
   ```swift
   static let useMockMode = true
   ```

3. **Set to `true` for mock mode:**
   ```swift
   static let useMockMode = true  // ✅ No server required
   ```

4. **Set to `false` for real API:**
   ```swift
   static let useMockMode = false  // Connects to Heroku backend
   ```

5. **Build and run** (⌘R)

That's it! The app will now use mock data instead of making real API calls.

---

## Testing with Mock Mode

### Test Sign Up

1. Open app in simulator
2. Tap "I'm a Healthcare Worker"
3. Fill in the form:
   - First Name: Test
   - Last Name: User
   - Email: test@example.com
   - Phone: 555-1234
   - Profession: Registered Nurse (RN)
   - License: RN123456
   - Password: TestPass123
   - Confirm Password: TestPass123
4. Check "I agree to Terms of Service"
5. Tap "Create Account"
6. **Wait 1.5 seconds (simulated network delay)**
7. ✅ See success message: "Account created successfully! (Mock Mode)"
8. ✅ Navigate to Dashboard
9. ✅ See welcome message with your name

### Test Sign In

1. Open app in simulator
2. Tap "Sign In" button (top right)
3. Enter any email and password:
   - Email: demo@example.com
   - Password: any password
4. Tap "Sign In"
5. **Wait 1 second (simulated network delay)**
6. ✅ See success message: "Sign in successful! (Mock Mode)"
7. ✅ Navigate to Dashboard
8. ✅ See "Demo User" profile

### Test Dashboard

After sign up or sign in, you'll see:
- ✅ Welcome message: "Welcome back, Demo!" (or your name)
- ✅ Your profession displayed
- ✅ All 4 tabs working (Home, Find Shifts, My Shifts, Profile)
- ✅ Profile shows mock user data
- ✅ Logout functionality works

---

## What Mock Mode Does

### Sign Up in Mock Mode

**Input:**
- All your form data (name, email, profession, etc.)

**Returns after 1.5 seconds:**
```json
{
  "message": "Account created successfully! (Mock Mode)",
  "token": "mock_token_abc-123",
  "user": {
    "id": "generated-uuid",
    "firstName": "Your First Name",
    "lastName": "Your Last Name",
    "email": "your@email.com",
    "profession": "RN",
    "licenseNumber": "Your License",
    ...
  }
}
```

### Sign In in Mock Mode

**Input:**
- Any email address
- Any password

**Returns after 1 second:**
```json
{
  "message": "Sign in successful! (Mock Mode)",
  "token": "mock_token_xyz-789",
  "user": {
    "id": "generated-uuid",
    "firstName": "Demo",
    "lastName": "User",
    "email": "demo@yolku.com",
    "profession": "RN",
    ...
  }
}
```

**Note:** In mock mode, any email/password combination will work for sign in!

---

## Switching Between Modes

### Development Workflow

**When building UI (Mock Mode):**
```swift
// In APIConfig.swift
static let useMockMode = true
```
- ✅ No server needed
- ✅ Fast iteration
- ✅ Predictable data
- ✅ Works offline

**When testing API integration (Real Mode):**
```swift
// In APIConfig.swift
static let useMockMode = false
```
- ✅ Real backend connection
- ✅ Actual database
- ✅ Real authentication
- ✅ Production testing

### Quick Comparison

| Feature | Mock Mode | Real Mode |
|---------|-----------|-----------|
| **Server Required** | ❌ No | ✅ Yes |
| **Network Required** | ❌ No | ✅ Yes |
| **Data Saved** | ❌ No | ✅ Yes (PostgreSQL) |
| **Speed** | ⚡ Instant | 🌐 Network delay |
| **Use Case** | UI testing, demos | Integration testing, production |
| **Any Email Works** | ✅ Yes | ❌ No (real validation) |
| **Any Password Works** | ✅ Yes | ❌ No (real validation) |

---

## Visual Indicator

When in mock mode, success messages include "(Mock Mode)" to remind you:

```
✅ Sign Up Success:
"Account created successfully! (Mock Mode)"

✅ Sign In Success:
"Sign in successful! (Mock Mode)"
```

This helps you know you're not using the real backend.

---

## Common Scenarios

### Scenario 1: Testing UI Only

**Goal:** Test form layouts, navigation, and UI flows

**Solution:**
```swift
static let useMockMode = true
```

**What You Can Test:**
- ✅ All form fields work
- ✅ Validation messages appear
- ✅ Loading spinners display
- ✅ Success messages show
- ✅ Navigation to dashboard works
- ✅ All tabs are accessible
- ✅ Profile displays correctly
- ✅ Logout works

**What Doesn't Work:**
- ❌ Real data not saved
- ❌ Can't retrieve real user data later
- ❌ Mock token isn't valid for real API

### Scenario 2: Demonstrating App

**Goal:** Show the app to someone without deploying backend

**Solution:**
```swift
static let useMockMode = true
```

**Benefits:**
- ✅ Works completely offline
- ✅ No setup required
- ✅ Fast and predictable
- ✅ Professional appearance
- ✅ All features appear to work

### Scenario 3: Integration Testing

**Goal:** Test with real Heroku backend

**Solution:**
```swift
static let useMockMode = false
```

**Requirements:**
- ✅ Heroku backend deployed
- ✅ Database initialized
- ✅ Network connection available
- ✅ Valid credentials (for sign in)

**What You Can Test:**
- ✅ Real authentication
- ✅ Data persistence
- ✅ Token validation
- ✅ Database queries
- ✅ Error handling with real API
- ✅ Network timeout handling

### Scenario 4: Offline Development

**Goal:** Develop features on a plane or without internet

**Solution:**
```swift
static let useMockMode = true
```

**What You Can Do:**
- ✅ Build new views
- ✅ Test navigation
- ✅ Design UI components
- ✅ Test state management
- ✅ Debug UI issues
- ✅ Prototype features

---

## Troubleshooting

### Issue: "Cannot connect to server"

**If you see this error, you might have mock mode disabled.**

**Solution:**
1. Open `APIConfig.swift`
2. Change `useMockMode` to `true`
3. Rebuild (⌘B)
4. Run (⌘R)

### Issue: Data not saved after sign up

**This is expected in mock mode!**

Mock mode doesn't save to database. It only simulates the response.

**Solutions:**
- **For UI testing:** Mock mode is perfect (already enabled)
- **For data testing:** Set `useMockMode = false` and use real backend

### Issue: Different user data on sign in

**In mock mode, sign in always returns "Demo User"**

This is by design. Mock mode uses fixed data for sign in.

**Solutions:**
- **For UI testing:** This is fine, test the dashboard features
- **For real user testing:** Set `useMockMode = false`

### Issue: Mock mode still tries to connect

**Make sure you saved the file and rebuilt!**

**Steps:**
1. Save `APIConfig.swift` (⌘S)
2. Clean build folder (⇧⌘K)
3. Build (⌘B)
4. Run (⌘R)

---

## Best Practices

### During Development

```swift
// Use mock mode for UI work
static let useMockMode = true
```

**Why:**
- Faster iteration
- No network delays
- Consistent test data
- Works offline

### Before Committing

```swift
// Switch to real mode to verify API still works
static let useMockMode = false
```

**Test:**
1. Sign up with real backend
2. Sign in with real credentials
3. Verify data persists
4. Check error handling

### For Demos

```swift
// Use mock mode for reliability
static let useMockMode = true
```

**Why:**
- No dependency on network
- Faster response times
- No risk of server being down
- Professional presentation

### For Production Testing

```swift
// Always use real mode
static let useMockMode = false
```

**Before App Store submission:**
1. Set `useMockMode = false`
2. Test all features with real backend
3. Verify production URL is correct
4. Test on real devices
5. Submit to TestFlight

---

## Network Delays in Mock Mode

Mock mode simulates realistic network delays:

| Operation | Simulated Delay | Why |
|-----------|----------------|-----|
| Sign In | 1.0 second | Typical authentication time |
| Sign Up | 1.5 seconds | Account creation is slower |
| Get Profile | 0.5 seconds | Simple data fetch |

This helps you test:
- ✅ Loading indicators appear
- ✅ User can see progress
- ✅ UI doesn't freeze
- ✅ Realistic user experience

---

## Summary

### Quick Reference

**Enable Mock Mode (No Server):**
```swift
// In APIConfig.swift, line ~13
static let useMockMode = true
```

**Enable Real Mode (Heroku Backend):**
```swift
// In APIConfig.swift, line ~13
static let useMockMode = false
```

### When to Use Each Mode

**Mock Mode (`true`):**
- 🎨 UI development
- 📱 Layout testing
- 🎭 Demos
- ✈️ Offline work
- ⚡ Fast iteration

**Real Mode (`false`):**
- 🔌 API integration testing
- 💾 Database testing
- 🔐 Authentication testing
- 🚀 Production testing
- 📲 App Store submission

---

## Next Steps

1. **Set Mock Mode:**
   ```swift
   static let useMockMode = true
   ```

2. **Build and Run:**
   ```bash
   ⌘B  # Build
   ⌘R  # Run
   ```

3. **Test Sign Up:**
   - Fill form
   - Create account
   - See dashboard

4. **Test Sign In:**
   - Enter any email/password
   - Sign in
   - See dashboard

5. **Explore Dashboard:**
   - Navigate all tabs
   - Check profile
   - Test logout

6. **When Ready for Real API:**
   ```swift
   static let useMockMode = false
   ```

---

## Additional Resources

- **API Configuration:** `YolkuApp/YolkuApp/APIConfig.swift`
- **API Service:** `YolkuApp/YolkuApp/APIService.swift`
- **Member Area Guide:** `MEMBER_AREA_GUIDE.md`
- **iOS Integration:** `iOS_API_INTEGRATION_GUIDE.md`
- **Backend Deployment:** `HEROKU_DEPLOYMENT_FIX.md`

---

**🎉 You can now test your iOS app without any server connection!**

Just set `useMockMode = true` and start testing!
