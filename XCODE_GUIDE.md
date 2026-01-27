# Yolku SwiftUI Implementation Guide

## Overview

This document explains how to open and work with the native iOS SwiftUI implementation of the Yolku landing page.

## Quick Start

### Opening in Xcode

1. **Using Terminal:**
   ```bash
   cd YolkuApp
   open YolkuApp.xcodeproj
   ```

2. **Using Finder:**
   - Navigate to the `YolkuApp` folder
   - Double-click `YolkuApp.xcodeproj`

3. **From Xcode:**
   - Open Xcode
   - File > Open
   - Select `YolkuApp.xcodeproj`

### Building and Running

1. Select a simulator (iPhone 15 Pro recommended) or your device from the scheme menu
2. Press ⌘R or click the Play button
3. The app will build and launch in the simulator

## Project Architecture

### SwiftUI Views

The landing page is divided into modular SwiftUI views:

| HTML Section | SwiftUI View | Description |
|-------------|--------------|-------------|
| Hero | `HeroView.swift` | Welcome section with gradient background |
| Features | `FeaturesView.swift` | Three feature cards with icons |
| App Preview | `AppPreviewView.swift` | Healthcare staffing description |
| Download | `DownloadView.swift` | App store buttons |
| Footer | `FooterView.swift` | Social links and copyright |

### Supporting Files

- **YolkuAppApp.swift**: App entry point with `@main` attribute
- **ContentView.swift**: Main container that composes all sections
- **ColorExtension.swift**: Hex color support for matching HTML colors
- **ButtonStyles.swift**: Custom button styles matching HTML design

## Design Implementation

### Colors

All colors from the HTML have been converted to SwiftUI:

```swift
// Primary gradient
LinearGradient(
    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

// Text colors
Color(hex: "333333")  // Primary text
Color(hex: "666666")  // Secondary text
Color(hex: "f8f9fa")  // Background
```

### Button Styles

Four custom button styles recreate the HTML buttons:

1. **GradientButtonStyle**: Primary CTA buttons
   - White text on gradient background
   - Used for: "Sign Up", "Get Started"

2. **OutlineButtonStyle**: Secondary buttons
   - Gradient color text with border
   - Used for: "Login"

3. **WhiteButtonStyle**: Hero primary button
   - Gradient color text on white background
   - Used for: "Download Now"

4. **OutlineWhiteButtonStyle**: Hero secondary button
   - White text with white border
   - Used for: "Learn More"

### Animations

SwiftUI provides built-in animations:

```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(.easeInOut(duration: 0.2), value: isPressed)
```

Feature cards have tap animations that scale up briefly when tapped.

## File Organization

```
YolkuApp/
├── YolkuApp.xcodeproj/          # Xcode project file
│   └── project.pbxproj           # Project configuration
│
├── YolkuApp/                     # Source code directory
│   ├── YolkuAppApp.swift         # App entry point
│   ├── ContentView.swift         # Main view
│   │
│   ├── Views/                    # (Conceptual grouping)
│   │   ├── HeroView.swift
│   │   ├── FeaturesView.swift
│   │   ├── AppPreviewView.swift
│   │   ├── DownloadView.swift
│   │   └── FooterView.swift
│   │
│   ├── Extensions/               # (Conceptual grouping)
│   │   └── ColorExtension.swift
│   │
│   ├── Styles/                   # (Conceptual grouping)
│   │   └── ButtonStyles.swift
│   │
│   └── Assets.xcassets/          # App assets
│       ├── AppIcon.appiconset/
│       └── Contents.json
│
├── README.md                     # iOS app documentation
└── .gitignore                    # Xcode gitignore

Note: Files are currently flat in YolkuApp/ directory.
You can organize them into groups in Xcode.
```

## Xcode Workflow

### Preview Canvas

Each view includes a `#Preview` macro for live previews:

```swift
#Preview {
    HeroView()
}
```

To see previews:
1. Open any view file
2. Press ⌘⌥↩ (Command + Option + Return)
3. Preview appears on the right side
4. Changes update in real-time

### Building

1. **Debug Build**: ⌘B
2. **Run**: ⌘R
3. **Clean Build Folder**: ⌘⇧K

### Simulator Selection

- Click on the scheme menu (next to Play button)
- Select from available simulators
- Recommended: iPhone 15 Pro, iPhone 15 Pro Max

### Troubleshooting

**Preview not working?**
- Try ⌘⌥P to refresh the preview
- Build the project first (⌘B)
- Check for syntax errors

**Build errors?**
- Clean build folder (⌘⇧K)
- Close and reopen Xcode
- Check Xcode version (requires 15.0+)

## Customization

### Changing Colors

Update hex values in views:

```swift
// In HeroView.swift
LinearGradient(
    colors: [Color(hex: "YOUR_COLOR"), Color(hex: "YOUR_COLOR")],
    ...
)
```

### Adding Icons

The current implementation uses emoji icons (🏥, 🔒, 📱). To use SF Symbols:

```swift
// Replace emoji
Text("🏥")

// With SF Symbol
Image(systemName: "cross.case.fill")
    .font(.system(size: 48))
    .foregroundColor(Color(hex: "667eea"))
```

### Modifying Layout

Each view is independent. Edit the view files to change:
- Spacing: Adjust `spacing` parameters
- Padding: Modify `.padding()` values
- Font sizes: Change `.font()` modifiers

## Comparison: HTML vs SwiftUI

| Feature | HTML/CSS | SwiftUI |
|---------|----------|---------|
| Layout | Flexbox/Grid | VStack/HStack |
| Styling | CSS classes | View modifiers |
| Colors | Hex strings | Color(hex:) |
| Gradients | CSS gradient | LinearGradient |
| Animations | CSS transitions | .animation() |
| Responsive | Media queries | Automatic |
| Preview | Browser | Xcode Canvas |

## Next Steps

### Add Navigation

Implement actual navigation:

```swift
Button("Download Now") {
    // Open App Store
    if let url = URL(string: "https://apps.apple.com/...") {
        UIApplication.shared.open(url)
    }
}
```

### Add Real Images

Replace emoji with actual images:

1. Add images to Assets.xcassets
2. Use `Image("imageName")` instead of `Text("emoji")`

### Connect to Backend

Add API calls to fetch real data:

```swift
@State private var features: [FeatureCard] = []

func loadFeatures() async {
    // Fetch from API
}
```

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Xcode Help](https://developer.apple.com/xcode/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)

---

**Ready to build! Open the project in Xcode and start coding.**
