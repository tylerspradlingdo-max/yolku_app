# Yolku - Healthcare Staffing Made Simple

> Connecting medical professionals with healthcare facilities

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

Yolku is a modern mobile application that bridges the gap between medical professionals and healthcare facilities. Our platform makes it easy for nurses, doctors, and allied health professionals to find shifts that match their skills and schedule, while helping healthcare facilities quickly fill their staffing needs.

This repository contains both a **web landing page** (HTML/CSS/JavaScript) and a **native iOS app** (SwiftUI) implementation.

## 📱 Available Implementations

### Web Landing Page
- **Location**: `index.html` (root directory)
- **Technology**: HTML5, CSS3, JavaScript
- **Deployment**: GitHub Pages, Netlify, Vercel
- **View Live**: Open `index.html` in a browser

### iOS App (SwiftUI)
- **Location**: `YolkuApp/` directory
- **Technology**: SwiftUI, iOS 17+
- **Deployment**: App Store, TestFlight
- **Recommended Branch**: `main` (for stable development) - [See branch guide](BRANCH_GUIDE.md)
- **Open in Xcode**: `open YolkuApp/YolkuApp.xcodeproj`
- **Documentation**: See [XCODE_GUIDE.md](XCODE_GUIDE.md)

## Features

✨ **Instant Connections** - Match with healthcare facilities in real-time and find shifts that fit your schedule and expertise.

🔒 **Secure & Compliant** - HIPAA-compliant platform ensuring your data and patient information remain secure and protected.

📱 **Simple Scheduling** - Manage shifts and availability with ease. Update your schedule on the go with our intuitive mobile app.

🏥 **Healthcare-Focused** - Purpose-built for the healthcare industry with features designed for medical professionals.

🌐 **Real-Time Updates** - Get instant notifications about new shifts and schedule changes.

💼 **Professional Profiles** - Showcase your credentials, certifications, and experience.

## Technologies Used

### Web Landing Page
- **HTML5** - Semantic markup for better accessibility
- **CSS3** - Modern styling with animations and responsive design
- **JavaScript** - Interactive features and smooth scrolling
- **Responsive Design** - Mobile-first approach that works on all devices

### iOS App
- **SwiftUI** - Native iOS UI framework
- **Xcode 15+** - Development environment
- **iOS 17+** - Target platform
- **Custom Components** - Reusable views and styles

## Repository Structure

```
yolku_app/
├── index.html              # Web landing page (HTML/CSS/JS)
├── README.md               # Main project documentation
├── LICENSE                 # MIT License
├── XCODE_GUIDE.md         # Complete guide for iOS app development
├── BRANCH_GUIDE.md        # Branch management guide for Xcode
└── YolkuApp/              # Native iOS app (SwiftUI)
    ├── README.md          # iOS-specific documentation
    ├── .gitignore         # Xcode gitignore
    ├── YolkuApp.xcodeproj/    # Xcode project file
    └── YolkuApp/          # Swift source code
        ├── YolkuAppApp.swift      # App entry point
        ├── ContentView.swift      # Main view
        ├── HeroView.swift         # Hero section
        ├── FeaturesView.swift     # Features section
        ├── AppPreviewView.swift   # App preview
        ├── DownloadView.swift     # Download section
        ├── FooterView.swift       # Footer
        ├── ColorExtension.swift   # Hex color support
        ├── ButtonStyles.swift     # Custom button styles
        └── Assets.xcassets/       # App assets
```

## Setup Instructions

### Web Landing Page

#### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/tylerspradlingdo-max/yolku_app.git
   cd yolku_app
   ```

2. **Open the landing page**
   - Simply open `index.html` in your web browser
   - Or use a local development server:
   
   **Using Python:**
   ```bash
   # Python 3
   python -m http.server 8000
   # Then visit http://localhost:8000
   ```
   
   **Using Node.js:**
   ```bash
   npx http-server
   # Then visit http://localhost:8080
   ```
   
   **Using PHP:**
   ```bash
   php -S localhost:8000
   # Then visit http://localhost:8000
   ```

3. **Start developing**
   - Edit `index.html` to make changes
   - Refresh your browser to see updates

### iOS App (SwiftUI)

#### Requirements
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 17.0+ (for deployment)

#### Quick Start

1. **Clone the repository** (if not already done)
   ```bash
   git clone https://github.com/tylerspradlingdo-max/yolku_app.git
   cd yolku_app
   ```

2. **Ensure you're on the main branch**
   ```bash
   # If you have uncommitted changes, see BRANCH_GUIDE.md for proper stash workflow
   git checkout main
   git pull origin main
   ```

3. **Open the Xcode project**
   ```bash
   cd YolkuApp
   open YolkuApp.xcodeproj
   ```

4. **Build and run**
   - Select a simulator (iPhone 15 Pro recommended) from the scheme menu
   - Press ⌘R to build and run
   - The app will launch in the simulator

5. **Explore the code**
   - All SwiftUI views are in `YolkuApp/YolkuApp/`
   - Each section is a separate view file
   - Press ⌘⌥↩ to see live previews

#### Detailed Guide
See [XCODE_GUIDE.md](XCODE_GUIDE.md) for comprehensive iOS development instructions.

## Deployment

### Web Landing Page

#### GitHub Pages

1. Go to your repository settings
2. Navigate to "Pages" section
3. Select source branch (main/master)
4. Save and wait for deployment
5. Your site will be available at `https://[username].github.io/yolku_app/`

#### Netlify

1. Sign up for a free [Netlify](https://www.netlify.com/) account
2. Click "New site from Git"
3. Connect your GitHub repository
4. Configure build settings (leave empty for static sites)
5. Click "Deploy site"

**Or use Netlify Drop:**
- Drag and drop the project folder to [Netlify Drop](https://app.netlify.com/drop)

#### Vercel

1. Sign up for a free [Vercel](https://vercel.com/) account
2. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```
3. Deploy:
   ```bash
   cd yolku_app
   vercel
   ```
4. Follow the prompts to complete deployment

**Or deploy via Vercel Dashboard:**
- Import your Git repository
- Configure project settings
- Click "Deploy"

## Design Specifications

### Color Palette
- **Primary Gradient:** `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
- **Text Primary:** `#333333`
- **Text Secondary:** `#666666`
- **Background Light:** `#f8f9fa`
- **White:** `#ffffff`

### Typography
- **Font Family:** System fonts (-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto)
- **Heading Sizes:** 2.5rem - 3.5rem
- **Body Text:** 1rem - 1.3rem
- **Line Height:** 1.6

### Responsive Breakpoints
- **Mobile:** < 768px
- **Tablet:** 768px - 1024px
- **Desktop:** > 1024px

### Layout
- **Max Container Width:** 1200px
- **Section Padding:** 80px vertical
- **Animations:** 0.3s transitions

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Accessibility

This landing page follows WCAG 2.1 Level AA guidelines:
- Semantic HTML5 elements
- ARIA labels for interactive elements
- Keyboard navigation support
- Sufficient color contrast ratios
- Responsive text sizing
- Alt text for images (when added)

## Contributing

We welcome contributions to improve the Yolku landing page! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test thoroughly**
   - Test on multiple browsers
   - Test responsive design on different screen sizes
   - Validate HTML/CSS
5. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style
- Maintain responsive design principles
- Ensure accessibility standards are met
- Test on multiple browsers and devices
- Update documentation as needed

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please open an issue in the GitHub repository.

---

**Built with ❤️ for healthcare professionals**