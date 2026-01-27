# API Integration Guide

This guide explains how to integrate the Yolku REST API with the iOS app and web frontend.

## Base URL

Development: `http://localhost:3000`
Production: `https://your-domain.com`

## iOS App Integration (SwiftUI)

### 1. Create API Service

Create a new file `YolkuApp/YolkuApp/Services/APIService.swift`:

```swift
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    // MARK: - Authentication
    
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        phoneNumber: String?,
        profession: String,
        licenseNumber: String?
    ) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any?] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber,
            "profession": profession,
            "licenseNumber": licenseNumber
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 })
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let url = URL(string: "\(baseURL)/auth/signin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func getProfile(token: String) async throws -> User {
        let url = URL(string: "\(baseURL)/users/profile")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        let profileResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
        return profileResponse.user
    }
}

// MARK: - Models

struct AuthResponse: Codable {
    let message: String
    let token: String
    let user: User
}

struct ProfileResponse: Codable {
    let user: User
}

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let profession: String
    let licenseNumber: String?
    let isVerified: Bool
    let isActive: Bool
    let lastLogin: String?
    let createdAt: String
    let updatedAt: String
}

enum APIError: Error {
    case invalidResponse
    case invalidData
    case serverError(String)
}
```

### 2. Update Sign In View

Update `SignInView.swift` to use the API:

```swift
@State private var isLoading = false
@State private var errorMessage: String?

func handleSignIn() {
    isLoading = true
    errorMessage = nil
    
    Task {
        do {
            let response = try await APIService.shared.signIn(
                email: email,
                password: password
            )
            
            // Store token securely
            UserDefaults.standard.set(response.token, forKey: "authToken")
            
            await MainActor.run {
                isLoading = false
                showSignIn = false
                // Navigate to main app
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = "Sign in failed. Please check your credentials."
            }
        }
    }
}
```

### 3. Update Sign Up View

Update `HealthcareWorkerSignUpView.swift`:

```swift
func handleSignUp() {
    isLoading = true
    errorMessage = nil
    
    Task {
        do {
            let response = try await APIService.shared.signUp(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                profession: profession,
                licenseNumber: licenseNumber.isEmpty ? nil : licenseNumber
            )
            
            // Store token securely
            UserDefaults.standard.set(response.token, forKey: "authToken")
            
            await MainActor.run {
                isLoading = false
                showSignUp = false
                // Navigate to main app
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = "Sign up failed. Please try again."
            }
        }
    }
}
```

## Web Integration (JavaScript)

### 1. Create API Client

Create `web/js/api.js`:

```javascript
const API_BASE_URL = 'http://localhost:3000/api';

class YolkuAPI {
  async signUp(userData) {
    const response = await fetch(`${API_BASE_URL}/auth/signup`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Sign up failed');
    }
    
    return await response.json();
  }
  
  async signIn(email, password) {
    const response = await fetch(`${API_BASE_URL}/auth/signin`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Sign in failed');
    }
    
    return await response.json();
  }
  
  async getProfile(token) {
    const response = await fetch(`${API_BASE_URL}/users/profile`, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (!response.ok) {
      throw new Error('Failed to get profile');
    }
    
    return await response.json();
  }
}

const api = new YolkuAPI();
```

### 2. Update Sign In Form

Update `signin.html` to use the API:

```html
<script src="js/api.js"></script>
<script>
document.getElementById('signinForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const email = document.getElementById('email').value;
  const password = document.getElementById('password').value;
  const errorDiv = document.getElementById('error');
  const submitButton = document.querySelector('button[type="submit"]');
  
  try {
    submitButton.disabled = true;
    submitButton.textContent = 'Signing in...';
    errorDiv.style.display = 'none';
    
    const response = await api.signIn(email, password);
    
    // Store token
    localStorage.setItem('authToken', response.token);
    localStorage.setItem('user', JSON.stringify(response.user));
    
    // Redirect to dashboard
    window.location.href = 'dashboard.html';
  } catch (error) {
    errorDiv.textContent = error.message;
    errorDiv.style.display = 'block';
    submitButton.disabled = false;
    submitButton.textContent = 'Sign In';
  }
});
</script>
```

### 3. Update Sign Up Form

Update `healthcare-worker-signup.html`:

```html
<script src="js/api.js"></script>
<script>
document.getElementById('signupForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const formData = {
    firstName: document.getElementById('firstName').value,
    lastName: document.getElementById('lastName').value,
    email: document.getElementById('email').value,
    password: document.getElementById('password').value,
    phoneNumber: document.getElementById('phone').value,
    profession: document.getElementById('profession').value,
    licenseNumber: document.getElementById('license').value
  };
  
  const errorDiv = document.getElementById('error');
  const submitButton = document.querySelector('button[type="submit"]');
  
  try {
    submitButton.disabled = true;
    submitButton.textContent = 'Creating Account...';
    errorDiv.style.display = 'none';
    
    const response = await api.signUp(formData);
    
    // Store token
    localStorage.setItem('authToken', response.token);
    localStorage.setItem('user', JSON.stringify(response.user));
    
    // Redirect to dashboard
    window.location.href = 'dashboard.html';
  } catch (error) {
    errorDiv.textContent = error.message;
    errorDiv.style.display = 'block';
    submitButton.disabled = false;
    submitButton.textContent = 'Create Account';
  }
});
</script>
```

## Testing the API

### 1. Using cURL

**Sign Up:**
```bash
curl -X POST http://localhost:3000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "password": "SecurePass123",
    "phoneNumber": "+1234567890",
    "profession": "RN",
    "licenseNumber": "RN123456"
  }'
```

**Sign In:**
```bash
curl -X POST http://localhost:3000/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "SecurePass123"
  }'
```

**Get Profile:**
```bash
curl http://localhost:3000/api/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 2. Using Postman

1. Import the collection
2. Set base URL variable: `http://localhost:3000`
3. Test each endpoint
4. Save the token from sign-in response
5. Use token in Authorization header for protected routes

## Security Best Practices

1. **Never commit `.env` file** - Contains sensitive credentials
2. **Use HTTPS in production** - Enable SSL/TLS
3. **Rotate JWT secrets regularly** - Change in production
4. **Implement rate limiting** - Prevent brute force attacks
5. **Validate all inputs** - Server-side validation is crucial
6. **Use secure password policies** - Minimum length, complexity
7. **Enable CORS properly** - Only allow trusted origins
8. **Store tokens securely** - Use Keychain on iOS, secure storage on web

## Troubleshooting

### Connection Refused
- Ensure backend server is running (`npm start`)
- Check if PORT is correct (default 3000)
- Verify firewall settings

### Database Errors
- Ensure PostgreSQL is running
- Check database credentials in `.env`
- Run `node scripts/init-db.js` to initialize

### CORS Errors
- Update `CORS_ORIGIN` in `.env`
- Include your frontend URL in allowed origins
- Ensure credentials: true if using cookies

### Token Errors
- Check token format: `Bearer <token>`
- Verify JWT_SECRET matches between requests
- Ensure token hasn't expired (default 7 days)

## Next Steps

1. Implement password reset functionality
2. Add email verification
3. Create facility sign-up endpoints
4. Add shift management endpoints
5. Implement real-time notifications
6. Add file upload for credentials
7. Integrate payment processing

## Support

For issues or questions:
- Check backend logs
- Review API documentation
- Test endpoints with Postman/cURL
- Verify database schema
