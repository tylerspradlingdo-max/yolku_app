# Adding Logo to iOS App

This guide explains how to add your logo to the Yolku iOS app.

## Option 1: Add Logo to Navigation Bar (Simple)

### Step 1: Add Logo Image to Assets Catalog

1. Open the project in Xcode:
   ```bash
   cd YolkuApp
   open YolkuApp.xcodeproj
   ```

2. In Xcode's Project Navigator, locate `Assets.xcassets`

3. Right-click on `Assets.xcassets` and select "New Image Set"

4. Name the image set `"AppLogo"`

5. Drag and drop your logo files:
   - 1x: Your logo at regular resolution (e.g., 120px wide)
   - 2x: Your logo at 2x resolution (e.g., 240px wide)
   - 3x: Your logo at 3x resolution (e.g., 360px wide)

### Step 2: Update ContentView to Use Logo Image

The code has been prepared to use an image logo. To activate it:

1. Open `ContentView.swift`
2. Locate the navigation bar logo section (around line 31)
3. Uncomment the Image logo code and comment out the Text logo

```swift
// Option 1: Use image logo (when you have logo in Assets)
Image("AppLogo")
    .resizable()
    .scaledToFit()
    .frame(height: 30)

// Option 2: Use text logo (current default)
// Text("Yolku")...
```

## Option 2: Add App Icon

### Required Sizes

You need to provide app icons in the following sizes:

| Size | Scale | Usage |
|------|-------|-------|
| 20x20 | 2x, 3x | iPhone Notification |
| 29x29 | 2x, 3x | iPhone Settings |
| 40x40 | 2x, 3x | iPhone Spotlight |
| 60x60 | 2x, 3x | iPhone App Icon |
| 76x76 | 1x, 2x | iPad App Icon |
| 83.5x83.5 | 2x | iPad Pro App Icon |
| 1024x1024 | 1x | App Store |

### Adding App Icons in Xcode

1. Open `YolkuApp.xcodeproj` in Xcode
2. Navigate to `Assets.xcassets` > `AppIcon`
3. Drag and drop your app icon files into the corresponding slots
4. Each slot is labeled with the required size

### Automated App Icon Generation

You can use online tools to generate all required sizes from a single high-res logo:
- https://www.appicon.co/
- https://makeappicon.com/

Simply upload your 1024x1024px logo and download the generated icons.

## Logo Design Guidelines

### For Navigation Bar Logo
- **Format**: PNG with transparent background
- **Dimensions**: 120x30px to 200x50px (1x), maintain aspect ratio for 2x and 3x
- **Color**: Should work well on white backgrounds
- **File size**: Keep under 50KB

### For App Icon
- **Format**: PNG with no transparency (required by Apple)
- **Shape**: Square (will be automatically rounded by iOS)
- **No alpha channels**: App icons cannot have transparency
- **Safe area**: Keep important elements in the center 80% to avoid cropping

## Current State

✅ Code is ready to support image logos
✅ CSS/styling is in place
⚠️ Logo image files need to be added to Assets.xcassets

## Need Help?

- [Apple's App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [SF Symbols for placeholder icons](https://developer.apple.com/sf-symbols/)
