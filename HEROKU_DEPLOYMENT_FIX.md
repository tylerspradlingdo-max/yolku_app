# Heroku Database Connection Fix

## Problem Fixed
The backend was unable to connect to PostgreSQL on Heroku because it was trying to connect to `localhost:5432` instead of using Heroku's `DATABASE_URL` environment variable.

**Error Message:**
```
❌ Unable to connect to the database: connect ECONNREFUSED 127.0.0.1:5432
```

## Solution Implemented
Updated `backend/config/database.js` to:
1. **Use `DATABASE_URL`** when available (Heroku production environment)
2. **Enable SSL** as required by Heroku Postgres
3. **Fall back** to individual env vars for local development

## Next Steps

### 1. Verify Heroku Has DATABASE_URL
In Heroku Dashboard → Settings → Config Vars, confirm:
- ✅ `DATABASE_URL` exists (auto-added by Heroku Postgres addon)
- ✅ `NODE_ENV` = `production`
- ✅ `JWT_SECRET` = [your secret]

### 2. Redeploy on Heroku
The code has been pushed to GitHub. To deploy:
- **Heroku Dashboard** → **Deploy** tab
- Click **"Deploy Branch"** to deploy the latest changes

OR if you have automatic deploys enabled, Heroku will deploy automatically.

### 3. Verify the Fix
After deployment completes (1-2 minutes), test the health endpoint:

**URL:** `https://yolku-9fce1d1d1bb6.herokuapp.com/api/health`

**Expected Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-27T...",
  "database": "connected"
}
```

### 4. Initialize Database Tables
Once the database connection is working, run the initialization script:

**Heroku Dashboard** → **More** → **Run console**

Run:
```bash
node backend/scripts/init-db.js
```

This will create the `Users` table in your PostgreSQL database.

### 5. Test the API
Try creating a test user:

```bash
curl -X POST https://yolku-9fce1d1d1bb6.herokuapp.com/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "test@example.com",
    "phoneNumber": "555-0100",
    "profession": "RN",
    "licenseNumber": "RN12345",
    "password": "SecurePass123!"
  }'
```

## Technical Details

### What Changed in database.js

**Before:**
```javascript
const sequelize = new Sequelize(
  process.env.DB_NAME || 'yolku_db',
  process.env.DB_USER || 'postgres',
  process.env.DB_PASSWORD || '',
  {
    host: process.env.DB_HOST || 'localhost',  // ❌ Always localhost
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres'
  }
);
```

**After:**
```javascript
if (process.env.DATABASE_URL) {
  // Production: Use Heroku's DATABASE_URL
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true,
        rejectUnauthorized: false  // Required for Heroku
      }
    }
  });
} else {
  // Local development: Use individual env vars
  sequelize = new Sequelize(
    process.env.DB_NAME || 'yolku_db',
    process.env.DB_USER || 'postgres',
    process.env.DB_PASSWORD || '',
    {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      dialect: 'postgres'
    }
  );
}
```

### Key Points
- ✅ **Heroku Postgres** requires SSL connections
- ✅ **DATABASE_URL** format: `postgres://user:pass@host:port/dbname`
- ✅ **Backward compatible** with local development
- ✅ **No changes needed** to Heroku Config Vars

## Troubleshooting

### If health check still shows "disconnected":

1. **Check Heroku logs:**
   ```
   Heroku Dashboard → More → View logs
   ```

2. **Verify Postgres addon is installed:**
   ```
   Resources tab → Search for "Heroku Postgres"
   ```
   Should see "Heroku Postgres" with status "Attached"

3. **Confirm DATABASE_URL exists:**
   ```
   Settings → Config Vars → DATABASE_URL should be present
   ```

4. **Check for typos in DATABASE_URL:**
   The format must be exactly: `postgres://...` (not `postgresql://`)

### If you see SSL/TLS errors:

The current configuration uses `rejectUnauthorized: false` which is the standard for Heroku Postgres. If you see SSL errors, the DATABASE_URL might be misconfigured.

## Success Indicators

✅ **Successful deployment** when you see in Heroku logs:
```
🚀 Yolku API Server running on port XXXX
📍 Environment: production
✅ Database connection established successfully
```

✅ **Health endpoint** returns:
```json
{
  "status": "healthy",
  "database": "connected"
}
```

✅ **API endpoints** are accessible:
- POST `/api/auth/signup`
- POST `/api/auth/signin`
- GET `/api/users/profile` (with auth token)

## Questions?

If you encounter any issues:
1. Check Heroku logs for detailed error messages
2. Verify all Config Vars are set correctly
3. Ensure Heroku Postgres addon is attached to your app
4. Confirm the app redeployed after the code changes
