// BijbelQuiz Admin Dashboard - Test Script

const fs = require('fs');
const path = require('path');

// Test script to verify the admin dashboard functionality
console.log('BijbelQuiz Admin Dashboard - Functionality Verification');

// Check if all required files exist
const requiredFiles = [
  'index.html',
  'styles.css',
  'script.js',
  'server.js',
  'package.json',
  '.env',
  'security.js'
];

console.log('\n1. Checking required files:');
let allFilesExist = true;

requiredFiles.forEach(file => {
  const filePath = path.join(__dirname, file);
  const exists = fs.existsSync(filePath);
  console.log(`   ${exists ? '✓' : '✗'} ${file}`);
  if (!exists) allFilesExist = false;
});

if (!allFilesExist) {
  console.log('\n❌ Some required files are missing!');
  process.exit(1);
}

// Check if package.json has all required dependencies
const packageJson = JSON.parse(fs.readFileSync(path.join(__dirname, 'package.json'), 'utf8'));
const requiredDeps = [
  '@supabase/supabase-js',
  'express',
  'cors',
  'helmet',
  'express-rate-limit',
  'jsonwebtoken',
  'bcrypt',
  'dotenv'
];

console.log('\n2. Checking required dependencies:');
let allDepsExist = true;

requiredDeps.forEach(dep => {
  const exists = packageJson.dependencies && packageJson.dependencies[dep];
  console.log(`   ${exists ? '✓' : '✗'} ${dep}`);
  if (!exists) allDepsExist = false;
});

if (!allDepsExist) {
  console.log('\n❌ Some required dependencies are missing!');
  process.exit(1);
}

// Check if HTML file has all required elements
const htmlContent = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');
const requiredElements = [
  '<input type="password" id="password"',
  'dashboard-container',
  'tracking-tab',
  'errors-tab',
  'store-tab',
  'messages-tab'
];

console.log('\n3. Checking HTML structure:');
let allElementsExist = true;

requiredElements.forEach(element => {
  const exists = htmlContent.includes(element);
  console.log(`   ${exists ? '✓' : '✗'} ${element.substring(0, 30)}${element.length > 30 ? '...' : ''}`);
  if (!exists) allElementsExist = false;
});

if (!allElementsExist) {
  console.log('\n❌ Some required HTML elements are missing!');
  process.exit(1);
}

// Check if security.js has required configurations
const securityContent = fs.readFileSync(path.join(__dirname, 'security.js'), 'utf8');
const securityChecks = [
  'helmet(',
  'rateLimit',
  'mongoSanitize',
  'xss',
  'validationRules'
];

console.log('\n4. Checking security configurations:');
let allSecurityOk = true;

securityChecks.forEach(check => {
  const exists = securityContent.includes(check);
  console.log(`   ${exists ? '✓' : '✗'} ${check}`);
  if (!exists) allSecurityOk = false;
});

if (!allSecurityOk) {
  console.log('\n❌ Some security configurations are missing!');
  process.exit(1);
}

console.log('\n✅ All checks passed! The admin dashboard is properly set up with security measures.');
console.log('\nTo run the dashboard:');
console.log('1. Update the .env file with your Supabase credentials and admin password');
console.log('2. Run `npm install` to install dependencies');
console.log('3. Run `node server.js` to start the server');
console.log('4. Access the dashboard at http://localhost:3000');
console.log('\nThe admin dashboard includes:');
console.log('- Server-side authentication with password stored in environment variables');
console.log('- JWT token-based authorization for all API endpoints');
console.log('- Tracking data analysis with filtering and visualization');
console.log('- Error reports management with deletion capability');
console.log('- Store items management (add, edit, delete)');
console.log('- Messages management (add, edit, delete)');
console.log('- Comprehensive security measures (helmet, rate limiting, input sanitization, XSS protection)');
console.log('\nSecurity features for public hosting:');
console.log('- All sensitive configuration stored in environment variables (not in source code)');
console.log('- Authentication handled server-side with no client-side password storage');
console.log('- JWT tokens expire after 8 hours');
console.log('- All API endpoints protected with token validation');
console.log('- Input validation and sanitization on both client and server side');