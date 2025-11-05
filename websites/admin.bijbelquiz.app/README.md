# BijbelQuiz Admin Dashboard

A secure admin dashboard for managing the BijbelQuiz application, including tracking data analysis, error reports, store management, and message management.

## Security Model

This admin dashboard implements multiple layers of security to ensure safe public hosting:

1. **Server-Side Authentication**: All authentication happens on the server, with the admin password stored securely in environment variables.

2. **JWT Token Validation**: After successful login, users receive a time-limited JWT token that must be included in the header of all subsequent API requests.

3. **API Endpoint Protection**: All API endpoints are protected by the `verifyToken` middleware, ensuring that only authenticated users can access sensitive data or perform administrative actions.

4. **Input Validation and Sanitization**: All user inputs are validated and sanitized to prevent injection attacks.

5. **Rate Limiting**: The application implements rate limiting to prevent abuse.

6. **Security Headers**: The application uses Helmet.js to set appropriate HTTP security headers.

## Setup

1. Create a `.env` file in the root directory with the following content:

```env
# Admin Dashboard Configuration
ADMIN_PASSWORD=your_secure_admin_password_here
SUPABASE_URL=your_supabase_url_here
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key_here
JWT_SECRET=your_jwt_secret_here
```

> **IMPORTANT**: Never commit the `.env` file to version control. Keep these credentials secure and only deploy them to trusted servers.

2. Install dependencies:
```bash
npm install
```

3. Start the server:
```bash
npm start
```

## Deployment

When deploying for public access:

1. Use HTTPS to encrypt all communications
2. Ensure the `.env` file is properly configured with strong passwords
3. Consider using additional authentication methods (e.g., 2FA) in front of the dashboard
4. Regularly update dependencies to patch security vulnerabilities
5. Monitor access logs for suspicious activity

### Vercel Deployment

This dashboard can be deployed on Vercel using the following steps:

1. Push your code to a GitHub repository
2. Import your project into Vercel
3. Set the following environment variables in the Vercel dashboard:
   - `ADMIN_PASSWORD`: Your admin password
   - `SUPABASE_URL`: Your Supabase project URL
   - `SUPABASE_SERVICE_ROLE_KEY`: Your Supabase service role key
   - `JWT_SECRET`: Secret for signing JWT tokens
4. Vercel will automatically detect and deploy your Node.js application
5. Access your dashboard at the URL provided by Vercel

## Architecture

- Client-side: HTML/CSS/JavaScript for the user interface
- Server-side: Node.js/Express server to handle authentication and API requests
- Database: Supabase for data storage
- Security: JWT tokens, input validation, rate limiting, and security headers

## API Security

All API endpoints require a valid JWT token in the Authorization header:

```
Authorization: Bearer <valid_jwt_token>
```

Unauthorized requests will receive a 401 (Unauthorized) or 403 (Forbidden) response.

## Data Security

- Read and write operations are limited to authenticated administrators
- All database queries are parameterized to prevent SQL injection
- User inputs are validated and sanitized before processing
- Sensitive operations (like deletion) require explicit confirmation

## Security Best Practices for Public Hosting

1. **Environment Variables**: Store all sensitive configuration in environment variables, never in the code
2. **HTTPS**: Always serve the dashboard over HTTPS to encrypt data in transit
3. **Strong Passwords**: Use a strong, complex admin password
4. **Regular Updates**: Keep all dependencies updated to patch security vulnerabilities
5. **Access Monitoring**: Monitor logs for unusual access patterns
6. **JWT Tokens**: JWT tokens expire after 8 hours to limit potential damage if compromised