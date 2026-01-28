# Logo Assets

This directory contains logo files for the Yolku app.

## Required Logo Files

### Web Application
Place your logo files here with the following naming conventions:

- **logo.png** - Main logo (recommended: 200x50px or similar aspect ratio)
- **logo@2x.png** - High-resolution version for retina displays (recommended: 400x100px)
- **logo-icon.png** - Square icon version (recommended: 100x100px)
- **favicon.ico** - Browser favicon (16x16, 32x32, 48x48px)

### iOS Application
For the iOS app, logo files should be placed in:
`YolkuApp/YolkuApp/Assets.xcassets/AppIcon.appiconset/`

Required sizes for iOS App Icon:
- iPhone App Icon: 120x120px (2x), 180x180px (3x)
- iPad App Icon: 76x76px (1x), 152x152px (2x)
- App Store: 1024x1024px (1x)

## File Format Recommendations

- **PNG** format with transparent background for best quality
- **SVG** format for scalable vector graphics (web only)
- Ensure adequate contrast for visibility on both light and dark backgrounds

## Current Status

⚠️ **Logo files need to be added by placing your logo images in this directory**

Once you add your logo files:
1. Place the logo files in this directory with the names specified above
2. The web application will automatically use them
3. For iOS, add the files to the Assets.xcassets folder via Xcode

## Fallback

If no logo files are provided, the application will use:
- Web: SVG logo defined in the HTML
- iOS: Default app icon configuration
