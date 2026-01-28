# Quick Start: Adding Your Logo to Yolku

This is a quick reference guide to help you add your logo to the Yolku app.

## What You Need

Your logo file(s) in PNG format with a transparent background.

## Step 1: Add Your Logo Files

### For Web Application

1. Save your logo file as `logo.png` (recommended size: 200x50 pixels)
2. Copy it to the `assets/images/` directory in the project root
3. Optionally, create a high-resolution version as `logo@2x.png` (400x100 pixels)

### For iOS Application

1. Open Xcode: `cd YolkuApp && open YolkuApp.xcodeproj`
2. In Xcode, click on `Assets.xcassets` in the Project Navigator
3. Right-click in the assets area and select "New Image Set"
4. Name it exactly: `AppLogo`
5. Drag your logo files into the 1x, 2x, and 3x slots
   - 1x: 120x30 pixels
   - 2x: 240x60 pixels  
   - 3x: 360x90 pixels

## Step 2: Update the Code

### For Web Application

Open `index.html` and find line 495. You'll see:

```html
<!-- Option 1: Use an image logo (recommended if you have a logo file)
     Replace the SVG below with:
     <img src="assets/images/logo.png" alt="Yolku" class="logo-icon logo-image">
     
     Option 2: Keep using SVG logo (current default)
-->
```

**Change it to:**

```html
<!-- Option 1: Image logo (currently using this) -->
<img src="assets/images/logo.png" alt="Yolku" class="logo-icon logo-image">

<!-- Option 2: SVG logo (commented out)
<svg class="logo-icon" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
    ... (rest of SVG code)
</svg>
-->
```

Optionally, do the same for `signin.html` (line 219) and `healthcare-worker-signup.html` (line 202).

### For iOS Application

**In ContentView.swift** (around line 31):

Change from:
```swift
// Option 1: Use image logo (uncomment when you add logo to Assets.xcassets)
// Image("AppLogo")
//     .resizable()
//     .scaledToFit()
//     .frame(height: 30)

// Option 2: Use text logo (current default)
Text("Yolku")
    .font(.title2)
    .fontWeight(.bold)
    ...
```

To:
```swift
// Option 1: Image logo (currently using this)
Image("AppLogo")
    .resizable()
    .scaledToFit()
    .frame(height: 30)

// Option 2: Text logo (commented out)
// Text("Yolku")
//     .font(.title2)
//     .fontWeight(.bold)
//     ...
```

**In HeroView.swift** (around line 22):

Make the same change - uncomment the Image code and comment out the Text code.

## Step 3: Test

### Web Application
```bash
# Start a local server
python3 -m http.server 8000

# Open http://localhost:8000 in your browser
```

Your logo should appear in the navigation bar!

### iOS Application

1. In Xcode, select a simulator (iPhone 15 Pro)
2. Press ⌘R to build and run
3. Your logo should appear in the navigation bar and hero section

## Troubleshooting

**Web: Logo not showing?**
- Check that `logo.png` is in `assets/images/` folder
- Check browser console for errors (F12)
- Clear browser cache

**iOS: Logo not showing?**
- Verify the image set is named exactly "AppLogo"
- Clean build folder in Xcode (⌘⇧K) and rebuild
- Make sure you uncommented the Image code

## Need More Help?

See the comprehensive guides:
- `LOGO_INTEGRATION_GUIDE.md` - Complete documentation
- `assets/images/README.md` - Web logo specifications
- `YolkuApp/LOGO_GUIDE.md` - iOS-specific instructions

## File Locations

```
yolku_app/
├── assets/
│   └── images/
│       └── logo.png              ← PUT YOUR WEB LOGO HERE
├── index.html                    ← UPDATE LINE 495
├── signin.html                   ← OPTIONAL: UPDATE LINE 219
├── healthcare-worker-signup.html ← OPTIONAL: UPDATE LINE 202
└── YolkuApp/
    └── YolkuApp/
        ├── Assets.xcassets/      ← ADD iOS LOGO HERE (via Xcode)
        ├── ContentView.swift     ← UPDATE LINE 31-42
        └── HeroView.swift        ← UPDATE LINE 22-33
```

That's it! Your logo is now integrated into the Yolku app. 🎉
