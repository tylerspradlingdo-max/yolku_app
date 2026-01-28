# Logo Integration Guide

This guide explains how to add your logo to the Yolku app (both web and iOS).

## Overview

The Yolku app has been prepared to support custom logo files. Currently, it uses placeholder text/SVG logos, but you can easily replace them with your actual logo images.

## Quick Start

### 1. Prepare Your Logo Files

You'll need your logo in the following formats:

#### For Web Application
- **logo.png** - Main logo (recommended: 200x50px, PNG with transparent background)
- **logo@2x.png** - High-res version (400x100px) for retina displays
- **favicon.ico** - Browser favicon (16x16, 32x32px)

#### For iOS Application  
- Multiple sizes for app icons (or use an online generator)
- Navigation logo: 120x30px (1x), 240x60px (2x), 360x90px (3x)

### 2. Add Logo Files

#### Web Application

1. Place your logo files in: `assets/images/`
   ```
   yolku_app/
   ├── assets/
   │   └── images/
   │       ├── logo.png          # Your main logo
   │       ├── logo@2x.png       # High-res version
   │       └── favicon.ico       # Browser icon
   ```

2. Update `index.html`:
   - Find the logo section (around line 495)
   - Uncomment this line:
     ```html
     <img src="assets/images/logo.png" alt="Yolku" class="logo-icon logo-image">
     ```
   - Comment out or remove the SVG logo code

3. Update favicon links in `<head>` (around line 11-14):
   - Uncomment the favicon link tags
   - Ensure the paths point to your favicon files

4. Optional: Update `signin.html` and `healthcare-worker-signup.html`:
   - Uncomment the image logo lines in these files as well

#### iOS Application

1. Open the Xcode project:
   ```bash
   cd YolkuApp
   open YolkuApp.xcodeproj
   ```

2. Add logo to Assets Catalog:
   - In Xcode, navigate to `Assets.xcassets`
   - Right-click → "New Image Set"
   - Name it "AppLogo"
   - Drag your logo files (1x, 2x, 3x versions)

3. Add App Icons:
   - Navigate to `Assets.xcassets` → `AppIcon`
   - Drag your app icon files to the corresponding slots
   - OR use an online tool like [appicon.co](https://www.appicon.co/) to generate all sizes

4. Update code files:
   - Open `ContentView.swift` (line 31-42)
   - Uncomment the Image logo code
   - Comment out the Text logo code
   
   - Open `HeroView.swift` (line 22-33)  
   - Uncomment the Image logo code
   - Comment out the Text logo code

## Detailed Instructions

### Web Application

#### File Structure
```
assets/
└── images/
    ├── logo.png          # Main logo for web
    ├── logo@2x.png       # Retina display version
    ├── logo-icon.png     # Square icon version
    ├── favicon.ico       # Browser favicon
    ├── favicon-16x16.png
    ├── favicon-32x32.png
    └── apple-touch-icon.png
```

#### Logo Specifications

| File | Dimensions | Format | Purpose |
|------|------------|--------|---------|
| logo.png | 200x50px | PNG (transparent) | Main navigation logo |
| logo@2x.png | 400x100px | PNG (transparent) | High-DPI displays |
| logo-icon.png | 100x100px | PNG | Square icon version |
| favicon.ico | 16x16, 32x32 | ICO | Browser tab icon |
| apple-touch-icon.png | 180x180px | PNG | iOS home screen |

#### CSS Classes Available

The following CSS classes are ready for use:

- `.logo` - Container for logo
- `.logo-icon` - SVG logo icon
- `.logo-icon.logo-image` - Image logo styling
- `.logo-text` - Logo text with gradient
- `.logo img` - Image logo in signin/signup pages

### iOS Application

#### App Icon Requirements

| Purpose | Size | Scale | Actual Pixels |
|---------|------|-------|---------------|
| iPhone Notification | 20x20 | 2x, 3x | 40x40, 60x60 |
| iPhone Settings | 29x29 | 2x, 3x | 58x58, 87x87 |
| iPhone Spotlight | 40x40 | 2x, 3x | 80x80, 120x120 |
| iPhone App | 60x60 | 2x, 3x | 120x120, 180x180 |
| iPad App | 76x76 | 1x, 2x | 76x76, 152x152 |
| iPad Pro | 83.5x83.5 | 2x | 167x167 |
| App Store | 1024x1024 | 1x | 1024x1024 |

#### Navigation Logo

For the navigation bar logo in `ContentView.swift` and hero section in `HeroView.swift`:
- Add an image set named "AppLogo" to Assets.xcassets
- Provide 1x, 2x, 3x versions
- Recommended size: 120x30px (1x), 240x60px (2x), 360x90px (3x)

#### Code Updates

**ContentView.swift** (around line 31-42):
```swift
// Uncomment to use image logo:
Image("AppLogo")
    .resizable()
    .scaledToFit()
    .frame(height: 30)

// Comment out text logo:
// Text("Yolku")...
```

**HeroView.swift** (around line 22-33):
```swift
// Uncomment to use image logo:
Image("AppLogo")
    .resizable()
    .scaledToFit()
    .frame(height: 60)

// Comment out text logo:
// Text("Yolku")...
```

## Logo Design Guidelines

### Best Practices

1. **Format**: PNG with transparent background (except App Icons)
2. **Aspect Ratio**: Wide logos (3:1 to 5:1 ratio) work best for navigation
3. **Colors**: Ensure visibility on both light and dark backgrounds
4. **File Size**: Keep web logos under 50KB for fast loading
5. **Quality**: Use vector graphics if possible, or high-resolution PNGs

### Avoid

- ❌ JPEG format (no transparency)
- ❌ Low resolution or pixelated logos
- ❌ Logos that are too tall (better to be wide)
- ❌ Excessive file sizes
- ❌ Transparency in iOS App Icons (not allowed by Apple)

## Tools & Resources

### Online Logo Generators
- [appicon.co](https://www.appicon.co/) - Generate iOS app icons
- [realfavicongenerator.net](https://realfavicongenerator.net/) - Generate favicons
- [makeappicon.com](https://makeappicon.com/) - All-in-one icon generator

### Design Tools
- Adobe Illustrator - Vector logo design
- Figma - Collaborative design
- Sketch - macOS design tool
- Canva - Simple online design

### Image Optimization
- [tinypng.com](https://tinypng.com/) - Compress PNG files
- [squoosh.app](https://squoosh.app/) - Advanced image compression
- ImageOptim (macOS) - Local image optimization

## Testing Your Logo

### Web Application

1. **Local Testing**:
   ```bash
   # Start a local server
   python -m http.server 8000
   # Or
   npx http-server
   ```
   
2. **Check**:
   - Logo displays correctly in navigation bar
   - Logo is crisp on high-DPI displays
   - Favicon appears in browser tab
   - Logo works on mobile devices

### iOS Application

1. **Run in Simulator**:
   - Open Xcode
   - Select a simulator (iPhone 15 Pro)
   - Press ⌘R to run
   - Check navigation bar and hero section

2. **Test on Device**:
   - Connect your iPhone/iPad
   - Select your device in Xcode
   - Build and run
   - Check app icon on home screen

## Troubleshooting

### Web Issues

**Logo not displaying:**
- Check file path is correct: `assets/images/logo.png`
- Verify file exists and is accessible
- Check browser console for 404 errors
- Clear browser cache

**Logo too large/small:**
- Check CSS `.logo-icon.logo-image` max-width and height
- Adjust image dimensions
- Use browser dev tools to inspect

**Favicon not showing:**
- Favicons can take time to update
- Clear browser cache and hard refresh (Ctrl+Shift+R)
- Check favicon.ico file format

### iOS Issues

**Logo not displaying:**
- Verify image set name is exactly "AppLogo"
- Check that images are added to Assets.xcassets
- Clean build folder (⌘⇧K) and rebuild

**App icon not showing:**
- Ensure all required sizes are provided
- App icons cannot have transparency
- Rebuild and reinstall app

**Logo looks blurry:**
- Provide all three resolutions (1x, 2x, 3x)
- Use higher resolution source images
- Check image is set to "Scale To Fill" in Xcode

## Current Status

✅ **Web Application**: Ready for logo integration
- Assets directory created
- HTML files updated with logo support
- CSS classes configured
- Comments added for easy integration

✅ **iOS Application**: Ready for logo integration  
- Code updated with logo support comments
- Asset catalog structure in place
- Documentation provided

⚠️ **Next Steps**: 
1. Add your logo files to the appropriate directories
2. Uncomment the image logo code
3. Test on both web and iOS

## Need Help?

- See `assets/images/README.md` for web-specific instructions
- See `YolkuApp/LOGO_GUIDE.md` for iOS-specific instructions
- Check [Apple's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- Review [Web Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

**Note**: The application currently works with placeholder text/SVG logos. Once you add your logo files and make the code changes described above, your custom logo will be integrated throughout the app.
