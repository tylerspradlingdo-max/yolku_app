# Yolku - Healthcare Staffing Made Simple

> Connecting medical professionals with healthcare facilities

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

Yolku is a modern mobile application that bridges the gap between medical professionals and healthcare facilities. Our platform makes it easy for nurses, doctors, and allied health professionals to find shifts that match their skills and schedule, while helping healthcare facilities quickly fill their staffing needs.

## Features

✨ **Instant Connections** - Match with healthcare facilities in real-time and find shifts that fit your schedule and expertise.

🔒 **Secure & Compliant** - HIPAA-compliant platform ensuring your data and patient information remain secure and protected.

📱 **Simple Scheduling** - Manage shifts and availability with ease. Update your schedule on the go with our intuitive mobile app.

🏥 **Healthcare-Focused** - Purpose-built for the healthcare industry with features designed for medical professionals.

🌐 **Real-Time Updates** - Get instant notifications about new shifts and schedule changes.

💼 **Professional Profiles** - Showcase your credentials, certifications, and experience.

## Technologies Used

- **HTML5** - Semantic markup for better accessibility
- **CSS3** - Modern styling with animations and responsive design
- **JavaScript** - Interactive features and smooth scrolling
- **Responsive Design** - Mobile-first approach that works on all devices

## Repository Structure

```
yolku_app/
├── index.html          # Main landing page
├── README.md           # Project documentation
└── LICENSE             # MIT License
```

## Setup Instructions

### Local Development

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

## Deployment

### GitHub Pages

1. Go to your repository settings
2. Navigate to "Pages" section
3. Select source branch (main/master)
4. Save and wait for deployment
5. Your site will be available at `https://[username].github.io/yolku_app/`

### Netlify

1. Sign up for a free [Netlify](https://www.netlify.com/) account
2. Click "New site from Git"
3. Connect your GitHub repository
4. Configure build settings (leave empty for static sites)
5. Click "Deploy site"

**Or use Netlify Drop:**
- Drag and drop the project folder to [Netlify Drop](https://app.netlify.com/drop)

### Vercel

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