// BijbelQuiz Admin Dashboard Server
// Handles authentication and API requests

const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const securityConfig = require('./security');
require('dotenv').config();

// Initialize Supabase client
const { createClient } = require('@supabase/supabase-js');

// Create express app
const app = express();
const PORT = process.env.PORT || 3000;

// Apply security middleware
app.use(securityConfig.helmet);
app.use(cors({
  origin: process.env.ADMIN_DASHBOARD_URL || 'https://admin.bijbelquiz.app',
  credentials: true
}));

app.use(express.json({ limit: '10mb' }));
// Serve static files from the current directory
app.use(express.static(__dirname));

// Apply security middlewares
app.use(securityConfig.rateLimit);
app.use(securityConfig.slowDown);
app.use(securityConfig.mongoSanitize);
app.use(securityConfig.xss);

// Additional security headers for all responses
app.use((req, res, next) => {
  // Prevent iframe embedding
  res.setHeader('X-Frame-Options', 'DENY');
  
  // Prevent MIME type sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');
  
  // Enable XSS protection in compatible browsers
  res.setHeader('X-XSS-Protection', '1; mode=block');
  
  next();
});

// JWT middleware to verify token
const verifyToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ error: 'Access denied. No token provided.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret');
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ error: 'Invalid or expired token.' });
  }
};

// Initialize Supabase client
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

if (!supabaseUrl || !supabaseKey) {
  console.error('Error: Missing Supabase configuration in environment variables');
  process.exit(1);
}

// Login endpoint
app.post('/api/login', securityConfig.validationRules.login, securityConfig.handleValidationErrors, async (req, res) => {
  try {
    const { password } = req.body;

    // Compare password with the one in environment variables
    // In a real implementation, you'd want to hash the password
    if (password === process.env.ADMIN_PASSWORD) {
      // Create JWT token
      const token = jwt.sign(
        { 
          userId: 'admin', 
          role: 'admin',
          exp: Math.floor(Date.now() / 1000) + (60 * 60 * 8) // 8 hours
        },
        process.env.JWT_SECRET || 'fallback_secret'
      );

      res.json({ 
        success: true, 
        token,
        message: 'Login successful'
      });
    } else {
      res.status(401).json({ error: 'Invalid password' });
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Verify endpoint - to check if the token is valid
app.post('/api/verify', verifyToken, (req, res) => {
  res.json({ valid: true, user: req.user });
});

// Load tracking data endpoint
app.get('/api/tracking-data', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    // Fetch tracking data from Supabase
    let query = supabase
      .from('tracking_events')
      .select('*')
      .order('timestamp', { ascending: false });

    // Apply filters if provided
    const { feature, action, dateFrom, dateTo } = req.query;
    
    if (feature && feature !== 'All') {
      query = query.eq('event_name', feature);
    }
    
    if (action && action !== 'All') {
      query = query.eq('event_type', action);
    }
    
    if (dateFrom) {
      query = query.gte('timestamp', dateFrom);
    }
    
    if (dateTo) {
      query = query.lte('timestamp', dateTo);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Error fetching tracking data:', error);
      return res.status(500).json({ error: 'Failed to fetch tracking data' });
    }

    res.json({ data });
  } catch (error) {
    console.error('Error in tracking data endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Load error reports endpoint
app.get('/api/error-reports', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    // Fetch error reports from Supabase
    let query = supabase
      .from('error_reports')
      .select('*')
      .order('timestamp', { ascending: false });

    // Apply filters if provided
    const { errorType, userId, questionId } = req.query;
    
    if (errorType && errorType !== '') {
      query = query.eq('error_type', errorType);
    }
    
    if (userId && userId !== '') {
      query = query.eq('user_id', userId);
    }
    
    if (questionId && questionId !== '') {
      query = query.eq('question_id', questionId);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Error fetching error reports:', error);
      return res.status(500).json({ error: 'Failed to fetch error reports' });
    }

    res.json({ data });
  } catch (error) {
    console.error('Error in error reports endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete error report endpoint
app.delete('/api/error-reports/:id', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const errorId = req.params.id;

    // Delete error report from Supabase
    const { error } = await supabase
      .from('error_reports')
      .delete()
      .eq('id', errorId);

    if (error) {
      console.error('Error deleting error report:', error);
      return res.status(500).json({ error: 'Failed to delete error report' });
    }

    res.json({ success: true, message: 'Error report deleted successfully' });
  } catch (error) {
    console.error('Error in delete error report endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Load store items endpoint
app.get('/api/store-items', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    // Fetch store items from Supabase
    let query = supabase
      .from('store_items')
      .select('*')
      .order('item_name');

    // Apply filters if provided
    const { itemType, search } = req.query;
    
    if (itemType && itemType !== '') {
      query = query.eq('item_type', itemType);
    }
    
    if (search && search !== '') {
      query = query.ilike('item_name', `%${search}%`);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Error fetching store items:', error);
      return res.status(500).json({ error: 'Failed to fetch store items' });
    }

    res.json({ data });
  } catch (error) {
    console.error('Error in store items endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update store item endpoint
app.put('/api/store-items/:id', verifyToken, securityConfig.validationRules.storeItem, securityConfig.handleValidationErrors, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const itemId = req.params.id;
    const updateData = req.body;

    // Update store item in Supabase
    const { data, error } = await supabase
      .from('store_items')
      .update(updateData)
      .eq('id', itemId)
      .select();

    if (error) {
      console.error('Error updating store item:', error);
      return res.status(500).json({ error: 'Failed to update store item' });
    }

    res.json({ success: true, data: data[0], message: 'Store item updated successfully' });
  } catch (error) {
    console.error('Error in update store item endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete store item endpoint
app.delete('/api/store-items/:id', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const itemId = req.params.id;

    // Delete store item from Supabase
    const { error } = await supabase
      .from('store_items')
      .delete()
      .eq('id', itemId);

    if (error) {
      console.error('Error deleting store item:', error);
      return res.status(500).json({ error: 'Failed to delete store item' });
    }

    res.json({ success: true, message: 'Store item deleted successfully' });
  } catch (error) {
    console.error('Error in delete store item endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new store item endpoint
app.post('/api/store-items', verifyToken, securityConfig.validationRules.storeItem, securityConfig.handleValidationErrors, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const newItemData = req.body;

    // Insert new store item to Supabase
    const { data, error } = await supabase
      .from('store_items')
      .insert([newItemData])
      .select();

    if (error) {
      console.error('Error adding store item:', error);
      return res.status(500).json({ error: 'Failed to add store item' });
    }

    res.json({ success: true, data: data[0], message: 'Store item added successfully' });
  } catch (error) {
    console.error('Error in add store item endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Load messages endpoint
app.get('/api/messages', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    // Fetch messages from Supabase
    let query = supabase
      .from('messages')
      .select('*')
      .order('created_at', { ascending: false });

    // Apply search filter if provided
    const { search } = req.query;
    
    if (search && search !== '') {
      query = query.or(`title.ilike.%${search}%,content.ilike.%${search}%`);
    }

    const { data, error } = await query;

    if (error) {
      console.error('Error fetching messages:', error);
      return res.status(500).json({ error: 'Failed to fetch messages' });
    }

    res.json({ data });
  } catch (error) {
    console.error('Error in messages endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update message endpoint
app.put('/api/messages/:id', verifyToken, securityConfig.validationRules.message, securityConfig.handleValidationErrors, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const messageId = req.params.id;
    const updateData = req.body;

    // Update message in Supabase
    const { data, error } = await supabase
      .from('messages')
      .update(updateData)
      .eq('id', messageId)
      .select();

    if (error) {
      console.error('Error updating message:', error);
      return res.status(500).json({ error: 'Failed to update message' });
    }

    res.json({ success: true, data: data[0], message: 'Message updated successfully' });
  } catch (error) {
    console.error('Error in update message endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete message endpoint
app.delete('/api/messages/:id', verifyToken, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const messageId = req.params.id;

    // Delete message from Supabase
    const { error } = await supabase
      .from('messages')
      .delete()
      .eq('id', messageId);

    if (error) {
      console.error('Error deleting message:', error);
      return res.status(500).json({ error: 'Failed to delete message' });
    }

    res.json({ success: true, message: 'Message deleted successfully' });
  } catch (error) {
    console.error('Error in delete message endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add new message endpoint
app.post('/api/messages', verifyToken, securityConfig.validationRules.message, securityConfig.handleValidationErrors, async (req, res) => {
  try {
    // Verify the user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Access denied. Admin role required.' });
    }

    const newMessageData = req.body;

    // Insert new message to Supabase
    const { data, error } = await supabase
      .from('messages')
      .insert([newMessageData])
      .select();

    if (error) {
      console.error('Error adding message:', error);
      return res.status(500).json({ error: 'Failed to add message' });
    }

    res.json({ success: true, data: data[0], message: 'Message added successfully' });
  } catch (error) {
    console.error('Error in add message endpoint:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Logout endpoint (client-side token invalidation)
app.post('/api/logout', verifyToken, (req, res) => {
  // On the client side, we just remove the token from local storage
  res.json({ success: true, message: 'Logout successful' });
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Serve the main page
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Handle 404 for API routes
app.use('/api/*', (req, res) => {
  res.status(404).json({ error: 'API endpoint not found' });
});

// Global error handler
app.use((error, req, res, next) => {
  console.error('Unhandled error:', error);
  res.status(500).json({ error: 'Internal server error' });
});

// Start the server
app.listen(PORT, () => {
  console.log(`BijbelQuiz Admin Dashboard server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;