# Fix: "Cannot find APIService in scope" Error

## Problem
The `APIService.swift` and `APIConfig.swift` files exist in your project folder but aren't added to the Xcode project file, so Xcode doesn't know about them.

## Quick Fix (2 Minutes)

### Step 1: Open Xcode
```bash
cd YolkuApp
open YolkuApp.xcodeproj
```

### Step 2: Add the Missing Files

**Method A: Right-Click Method (Recommended)**

1. In Xcode's left sidebar (Project Navigator), find the **YolkuApp** folder (the blue folder icon)
2. **Right-click** on the YolkuApp folder
3. Select **"Add Files to YolkuApp..."**
4. In the file picker dialog:
   - Navigate to `YolkuApp/YolkuApp/` folder
   - You should see `APIConfig.swift` and `APIService.swift`
   - Hold ⌘ (Command) and click both files to select them
5. **IMPORTANT:** In the bottom of the dialog:
   - **UNCHECK** ☐ "Copy items if needed" (files are already in the right place)
   - **CHECK** ☑ "Add to targets: YolkuApp"
6. Click **"Add"** button

**Method B: Drag and Drop Method (Faster)**

1. Open **Finder** and navigate to your project folder: `YolkuApp/YolkuApp/`
2. You should see:
   - `APIConfig.swift`
   - `APIService.swift`
3. Select both files (hold ⌘ and click each)
4. **Drag** them into Xcode's Project Navigator onto the YolkuApp group
5. In the dialog that appears:
   - **UNCHECK** ☐ "Copy items if needed"
   - **CHECK** ☑ "Add to targets: YolkuApp"
6. Click **"Finish"**

### Step 3: Verify Files Are Added

After adding the files, check the Project Navigator in Xcode:

```
YolkuApp (project)
└── YolkuApp (folder)
    ├── YolkuAppApp.swift
    ├── ContentView.swift
    ├── HeroView.swift
    ├── FeaturesView.swift
    ├── APIConfig.swift          ← Should be here now!
    ├── APIService.swift         ← Should be here now!
    ├── SignInView.swift
    ├── HealthcareWorkerSignUpView.swift
    ├── ... (other files)
```

### Step 4: Build and Run

1. Press **⌘B** to build
   - Should build successfully with no errors!
2. Press **⌘R** to run
   - App should launch!
3. Test the API integration:
   - Tap "I'm a Healthcare Worker"
   - Fill out the form
   - Tap "Create Account"
   - Should connect to the production API!

## Troubleshooting

### Error Still Appears?

**Check 1: Files are in the target**
1. Select `APIConfig.swift` in Project Navigator
2. Open the **File Inspector** (⌘⌥1 or View → Inspectors → File)
3. Under "Target Membership", make sure **YolkuApp** is checked ☑

**Check 2: Clean build folder**
1. In Xcode menu: **Product → Clean Build Folder** (⇧⌘K)
2. Try building again (⌘B)

**Check 3: Restart Xcode**
1. Quit Xcode completely (⌘Q)
2. Reopen the project
3. Build again

### Files Not Showing in File Picker?

The files are located at:
```
YolkuApp/
└── YolkuApp/
    ├── APIConfig.swift     ← HERE
    └── APIService.swift    ← HERE
```

### Still Having Issues?

**Manual verification:**
```bash
# Check files exist
cd YolkuApp/YolkuApp
ls -la API*.swift

# Should show:
# APIConfig.swift
# APIService.swift
```

If files don't exist, they may not have been committed. Pull the latest changes:
```bash
cd /path/to/yolku_app
git pull origin copilot/create-landing-page-for-yolku
```

## What These Files Do

**APIConfig.swift**
- Stores the production API URL: `https://yolku-9fce1d1d1bb6.herokuapp.com`
- Automatically switches between dev (localhost) and production URLs
- Defines all API endpoints (auth, users, health)

**APIService.swift**
- Handles all API calls (sign in, sign up, get profile)
- Manages authentication tokens
- Handles errors and network issues
- Uses modern Swift async/await

## After Fixing

Once the files are added and the app builds:

1. **Test Sign Up:**
   - Run the app (⌘R)
   - Tap "I'm a Healthcare Worker"
   - Fill in the form
   - Tap "Create Account"
   - Should see: "Account created successfully! Welcome to Yolku, [Your Name]!"

2. **Test Sign In:**
   - Tap "Sign In" button
   - Enter your email and password
   - Should see: "Sign in successful! Welcome back, [Your Name]!"

3. **Backend Connection:**
   - The app is now talking to your live Heroku backend!
   - All data is stored in the production PostgreSQL database

## Next Steps

- ✅ Files added to Xcode project
- ✅ App builds successfully
- ✅ API integration working
- ⬜ Test on real device (optional)
- ⬜ Create app icon
- ⬜ Submit to App Store

---

**Need Help?**

If you're still stuck, check:
- `iOS_API_INTEGRATION_GUIDE.md` - Complete iOS integration guide
- `DEPLOYMENT_SUMMARY.md` - Full deployment overview
- `backend/API_INTEGRATION.md` - API reference

**Production API:** `https://yolku-9fce1d1d1bb6.herokuapp.com`
**Health Check:** `https://yolku-9fce1d1d1bb6.herokuapp.com/api/health`
