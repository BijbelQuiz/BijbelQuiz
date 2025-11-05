// Security configuration for BijbelQuiz Admin Dashboard

const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const { body, validationResult } = require('express-validator');

// Security middleware configuration
const securityConfig = {
  // Helmet configuration for HTTP headers security
  helmet: helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
        fontSrc: ["'self'", "https://fonts.gstatic.com"],
        imgSrc: ["'self'", "data:", "https:"],
        scriptSrc: ["'self'"],
        connectSrc: ["'self'", process.env.SUPABASE_URL || ''],
      },
    },
    hsts: {
      maxAge: 31536000, // 1 year in seconds
      includeSubDomains: true,
      preload: true
    },
    referrerPolicy: {
      policy: 'no-referrer'
    }
  }),

  // Rate limiting configuration
  rateLimit: rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // Limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.',
    standardHeaders: true,
    legacyHeaders: false
  }),

  // Slow down repeated requests
  slowDown: slowDown({
    windowMs: 15 * 60 * 1000, // 15 minutes
    delayAfter: 50, // Begin slowing down after 50 requests
    delayMs: 500 // Each request after the 50th will be delayed by 500ms
  }),

  // Input sanitization
  mongoSanitize: mongoSanitize({
    allowDots: true,
    replaceWith: '_'
  }),

  // XSS protection
  xss: xss(),

  // Validation rules for various endpoints
  validationRules: {
    login: [
      body('password')
        .trim()
        .notEmpty()
        .withMessage('Password is required')
        .isLength({ min: 1 })
        .withMessage('Password cannot be empty')
    ],
    
    storeItem: [
      body('item_key')
        .trim()
        .isLength({ min: 1, max: 50 })
        .withMessage('Item key must be between 1 and 50 characters')
        .matches(/^[a-zA-Z0-9_-]+$/)
        .withMessage('Item key can only contain letters, numbers, hyphens, and underscores'),
        
      body('item_name')
        .trim()
        .isLength({ min: 1, max: 100 })
        .withMessage('Item name must be between 1 and 100 characters'),
        
      body('item_type')
        .isIn(['powerup', 'theme', 'feature'])
        .withMessage('Item type must be powerup, theme, or feature'),
        
      body('base_price')
        .isInt({ min: 0 })
        .withMessage('Base price must be a non-negative integer'),
        
      body('discount_percentage')
        .optional()
        .isInt({ min: 0, max: 100 })
        .withMessage('Discount percentage must be between 0 and 100')
    ],
    
    message: [
      body('title')
        .trim()
        .isLength({ min: 1, max: 200 })
        .withMessage('Title must be between 1 and 200 characters'),
        
      body('content')
        .trim()
        .isLength({ min: 1, max: 5000 })
        .withMessage('Content must be between 1 and 5000 characters'),
        
      body('expiration_date')
        .isISO8601()
        .withMessage('Expiration date must be a valid ISO 8601 date')
    ]
  },

  // Error handler for validation results
  handleValidationErrors: (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation failed',
        details: errors.array()
      });
    }
    next();
  }
};

module.exports = securityConfig;