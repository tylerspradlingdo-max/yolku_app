# Yolku Backend API

REST API backend for the Yolku healthcare staffing application.

## Features

- ✅ User authentication (sign up / sign in)
- ✅ JWT token-based authorization
- ✅ Healthcare worker profile management
- ✅ PostgreSQL database with Sequelize ORM
- ✅ Input validation and sanitization
- ✅ Security best practices (Helmet, CORS, etc.)
- ✅ Request logging
- ✅ Health check endpoint

## Tech Stack

- **Node.js** - Runtime environment
- **Express** - Web framework
- **PostgreSQL** - Database
- **Sequelize** - ORM
- **JWT** - Authentication
- **bcryptjs** - Password hashing

## Prerequisites

- Node.js >= 18.0.0
- PostgreSQL >= 13
- npm >= 9.0.0

## Installation

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Set up PostgreSQL database:**
   ```sql
   CREATE DATABASE yolku_db;
   ```

3. **Configure environment variables:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and update with your configuration:
   - Database credentials
   - JWT secret (use a strong random string)
   - Server port
   - CORS origins

4. **Initialize database:**
   ```bash
   node scripts/init-db.js
   ```

## Running the Server

### Development mode (with auto-reload):
```bash
npm run dev
```

### Production mode:
```bash
npm start
```

The server will start on `http://localhost:3000` (or your configured PORT).

## API Endpoints

### Health Check
```http
GET /api/health
```
Returns server health status and database connection.

### Authentication

#### Sign Up
```http
POST /api/auth/signup
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "SecurePass123",
  "phoneNumber": "+1234567890",
  "profession": "RN",
  "licenseNumber": "RN123456"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "profession": "RN",
    ...
  }
}
```

#### Sign In
```http
POST /api/auth/signin
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "SecurePass123"
}
```

**Response:**
```json
{
  "message": "Signed in successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    ...
  }
}
```

#### Verify Token
```http
POST /api/auth/verify
Content-Type: application/json

{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### User Profile

#### Get Profile
```http
GET /api/users/profile
Authorization: Bearer {token}
```

#### Update Profile
```http
PUT /api/users/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith",
  "phoneNumber": "+1234567890",
  "profession": "NP",
  "licenseNumber": "NP789012"
}
```

## Professions

Supported healthcare professions:
- RN (Registered Nurse)
- LPN (Licensed Practical Nurse)
- CNA (Certified Nursing Assistant)
- Doctor
- PA (Physician Assistant)
- NP (Nurse Practitioner)
- Therapist
- Pharmacist
- Other

## Security

- Passwords are hashed using bcryptjs with salt rounds
- JWT tokens for stateless authentication
- Helmet for security headers
- CORS configuration for allowed origins
- Input validation and sanitization
- SQL injection protection via Sequelize ORM

## Database Schema

### Users Table
```sql
- id (UUID, primary key)
- firstName (VARCHAR)
- lastName (VARCHAR)
- email (VARCHAR, unique)
- password (VARCHAR, hashed)
- phoneNumber (VARCHAR, optional)
- profession (ENUM)
- licenseNumber (VARCHAR, optional)
- isVerified (BOOLEAN, default false)
- isActive (BOOLEAN, default true)
- lastLogin (TIMESTAMP)
- createdAt (TIMESTAMP)
- updatedAt (TIMESTAMP)
```

## Error Handling

All API errors follow this format:
```json
{
  "error": "Error message",
  "status": 400
}
```

Or for validation errors:
```json
{
  "errors": [
    {
      "msg": "Error message",
      "param": "fieldName",
      "location": "body"
    }
  ]
}
```

## Deployment

### Heroku
```bash
# Login to Heroku
heroku login

# Create app
heroku create yolku-api

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:hobby-dev

# Set environment variables
heroku config:set JWT_SECRET=your_secret_key
heroku config:set NODE_ENV=production

# Deploy
git push heroku main

# Initialize database
heroku run node scripts/init-db.js
```

### AWS / DigitalOcean / Other
1. Set up PostgreSQL database
2. Configure environment variables
3. Run `npm install --production`
4. Run `node scripts/init-db.js`
5. Start with `npm start`
6. Use a process manager like PM2 for production

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Server port | 3000 |
| NODE_ENV | Environment | development |
| DB_HOST | Database host | localhost |
| DB_PORT | Database port | 5432 |
| DB_NAME | Database name | yolku_db |
| DB_USER | Database user | postgres |
| DB_PASSWORD | Database password | - |
| JWT_SECRET | JWT signing secret | - |
| JWT_EXPIRE | Token expiration | 7d |
| CORS_ORIGIN | Allowed origins | * |

## Testing

```bash
npm test
```

## License

MIT
