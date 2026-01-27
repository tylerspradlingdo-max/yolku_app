# Yolku iOS App

Native SwiftUI implementation of the Yolku healthcare staffing landing page.

## Overview

This is a native iOS application built with SwiftUI that recreates the Yolku landing page design. The app features a modern, gradient-based design connecting medical professionals with healthcare facilities.

## Requirements

- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 13.0 or later (for development)

## Project Structure

```
YolkuApp/
├── YolkuApp.xcodeproj/       # Xcode project file
│   └── project.pbxproj
└── YolkuApp/                  # Source code
    ├── YolkuAppApp.swift      # App entry point
    ├── ContentView.swift      # Main container view
    ├── HeroView.swift         # Hero section
    ├── FeaturesView.swift     # Features section with cards
    ├── AppPreviewView.swift   # App preview section
    ├── DownloadView.swift     # Download section
    ├── FooterView.swift       # Footer with social links
    ├── ColorExtension.swift   # Hex color support
    ├── ButtonStyles.swift     # Custom button styles
    └── Assets.xcassets/       # App icons and assets
```

## Features

### Views

- **HeroView**: Welcome section with gradient background
- **FeaturesView**: Three feature cards highlighting key benefits
- **AppPreviewView**: Description of the healthcare staffing platform
- **DownloadView**: App store download buttons
- **FooterView**: Social media links and copyright

### Design

- **Gradient Theme**: Linear gradient from #667eea to #764ba2
- **Custom Button Styles**: Gradient, outline, and white button variations
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Interactive elements with spring animations

## How to Open in Xcode

1. **Navigate to the project directory**:
   ```bash
   cd YolkuApp
   ```

2. **Open the Xcode project**:
   ```bash
   open YolkuApp.xcodeproj
   ```
   
   Or double-click `YolkuApp.xcodeproj` in Finder

3. **Select a simulator or device** from the scheme menu

4. **Build and run** (⌘R) to see the app in action

## Building the App

### From Xcode

1. Open `YolkuApp.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press ⌘R to build and run
4. The app will launch in the simulator or on your device

### From Command Line

```bash
cd YolkuApp
xcodebuild -project YolkuApp.xcodeproj -scheme YolkuApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## Customization

### Colors

All colors are defined using hex values in the views. The main gradient colors are:
- Primary: `#667eea`
- Secondary: `#764ba2`

Update these in the views to change the color scheme.

### Button Styles

Custom button styles are defined in `ButtonStyles.swift`:
- `GradientButtonStyle`: Primary CTA buttons with gradient
- `OutlineButtonStyle`: Secondary buttons with outline
- `WhiteButtonStyle`: White buttons for dark backgrounds
- `OutlineWhiteButtonStyle`: White outline buttons

## Code Structure

### SwiftUI Views

Each section of the landing page is a separate SwiftUI view for modularity and reusability:

```swift
struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeroView()
                FeaturesView()
                AppPreviewView()
                DownloadView()
                FooterView()
            }
        }
    }
}
```

### Color Extension

The `ColorExtension.swift` file provides hex color support:

```swift
Color(hex: "667eea")  // Create colors from hex strings
```

## Testing

The project includes SwiftUI previews for each view. To see previews:

1. Open any view file in Xcode
2. Press ⌘⌥↩ to show the preview canvas
3. Click "Resume" if the preview is paused

## Deployment

### TestFlight

1. Archive the app (Product > Archive)
2. Distribute to TestFlight
3. Upload to App Store Connect

### App Store

1. Configure app metadata in App Store Connect
2. Submit for review
3. Once approved, release to the App Store

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Related Files

- Original HTML landing page: `../index.html`
- Project documentation: `../README.md`

---

**Built with SwiftUI for iOS**
