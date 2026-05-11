# iOS App Production API Integration Guide

## ✅ Setup Complete!

Your iOS app is now configured to use the production Heroku backend:
**`https://yolku-9fce1d1d1bb6.herokuapp.com`**

## How to Use

### 1. Open the Project in Xcode

```bash
cd YolkuApp
open YolkuApp.xcodeproj
```

### 2. Build Configuration

The app now uses the production API by default, including normal Xcode debug runs.

- **DEBUG builds** (running in Xcode): Uses `https://yolku-9fce1d1d1bb6.herokuapp.com` by default
- **RELEASE builds** (Archive for App Store): Uses `https://yolku-9fce1d1d1bb6.herokuapp.com`

To point a debug build at a local backend instead:
1. Open `YolkuApp/YolkuApp/APIConfig.swift`
2. Set `useLocalDevelopmentServer` to `true`
3. Run the app (⌘R)

### 3. Test the Sign Up Flow

1. Run the app in Xcode
2. Tap **"I'm a Healthcare Worker"** button
3. Fill in the form:
   - First Name: John
   - Last Name: Doe
   - Email: john.doe@test.com
   - Phone: (555) 123-4567
   - Profession: Select "Registered Nurse (RN)"
   - License Number: RN123456
   - Password: TestPass123
   - Confirm Password: TestPass123
   - ✓ Agree to Terms
4. Tap **"Create Account"**
5. You should see: "Account created successfully! Welcome to Yolku, John!"

### 4. Test the Sign In Flow

1. Tap **"Sign In"** button in navigation
2. Enter credentials:
   - Email: john.doe@test.com
   - Password: TestPass123
3. Tap **"Sign In"**
4. You should see: "Sign in successful! Welcome back, John!"

## API Configuration

### Files Created

1. **`APIConfig.swift`** - API URL configuration
   ```swift
   // Production URL
   static let productionURL = "https://yolku-9fce1d1d1bb6.herokuapp.com"
   
   // Development URL
   static let developmentURL = "http://localhost:3000"

   #if DEBUG
   static let useLocalDevelopmentServer = false
   static let baseURL = useLocalDevelopmentServer ? developmentURL : productionURL
   #else
   static let baseURL = productionURL
   #endif
   ```

2. **`APIService.swift`** - API service methods
   ```swift
   // Sign in
   let response = try await APIService.shared.signIn(email: email, password: password)
   
   // Sign up
   let response = try await APIService.shared.signUp(
       firstName: firstName,
       lastName: lastName,
       email: email,
       password: password,
       phoneNumber: phone,
       profession: "RN",
       licenseNumber: license
   )
   ```

### Updated Views

1. **`SignInView.swift`** - Now calls real API
2. **`HealthcareWorkerSignUpView.swift`** - Now calls real API

## Features

### ✅ Loading States
- Shows spinner during API calls
- Buttons disabled while loading
- Professional user experience

### ✅ Error Handling
- Network errors: "Network error. Please check your connection..."
- Server errors: Displays actual error message from API
- Validation errors: Client-side validation before API call

### ✅ Success Messages
- Personalized welcome messages
- Uses user's first name from API response

### ✅ Token Storage
- JWT token stored in UserDefaults
- User info stored for personalization
- Ready for authenticated API calls

## Troubleshooting

### "Network error" message
- Check internet connection
- Verify Heroku app is running: `https://yolku-9fce1d1d1bb6.herokuapp.com/api/health`
- Should see: `{"status":"healthy","database":"connected"}`

### "Invalid URL" error
- Check APIConfig.swift has correct production URL
- Ensure no typos in the URL

### Email already exists
- Try a different email address
- Or use the sign in flow instead

### Password doesn't match
- Passwords must match exactly
- Passwords must be at least 8 characters

## API Endpoints

### Authentication
- **Sign Up**: `POST /api/auth/signup`
- **Sign In**: `POST /api/auth/signin`
- **Verify Token**: `POST /api/auth/verify`

### User Management
- **Get Profile**: `GET /api/users/profile` (requires Bearer token)
- **Update Profile**: `PUT /api/users/profile` (requires Bearer token)

### Health Check
- **Check Status**: `GET /api/health`

## Next Steps

### For Development
1. Test all features in the iOS app
2. Verify API calls work correctly
3. Test error scenarios (wrong password, network issues, etc.)

### For Production
1. Switch to RELEASE build configuration
2. Test with production API
3. Create app icon (1024x1024)
4. Set bundle identifier in Xcode
5. Archive and upload to App Store Connect

### Future Enhancements
1. Use Keychain instead of UserDefaults for token storage
2. Implement token refresh logic
3. Add profile view to display user data
4. Implement password reset flow
5. Add biometric authentication (Face ID/Touch ID)

## Security Notes

- ✅ All production API calls use HTTPS
- ✅ Passwords are hashed on the server
- ✅ JWT tokens expire after 7 days
- ✅ Tokens stored securely in UserDefaults
- 🔄 Consider Keychain for enhanced security (future)

## Support

If you encounter issues:

1. **Check Heroku logs**:
   - Heroku Dashboard → More → View logs

2. **Test API directly**:
   ```bash
   curl -X POST https://yolku-9fce1d1d1bb6.herokuapp.com/api/auth/signup \
     -H "Content-Type: application/json" \
     -d '{
       "firstName": "Test",
       "lastName": "User",
       "email": "test@example.com",
       "password": "TestPass123",
       "profession": "RN",
       "phoneNumber": "1234567890",
       "licenseNumber": "RN123"
     }'
   ```

3. **Check iOS console**:
   - Xcode → View → Debug Area → Show Debug Area
   - Look for error messages

## Success Criteria

✅ App builds without errors
✅ Can create new account through app
✅ Can sign in with created account  
✅ Success messages appear after authentication
✅ Loading spinners show during API calls
✅ Error messages display for invalid input

## Production URL

Your live backend API:
**`https://yolku-9fce1d1d1bb6.herokuapp.com`**

Check health status:
**`https://yolku-9fce1d1d1bb6.herokuapp.com/api/health`**

Expected response:
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2026-01-27T..."
}
```

---

**🎉 Your iOS app is now connected to the production backend and ready for testing!**
