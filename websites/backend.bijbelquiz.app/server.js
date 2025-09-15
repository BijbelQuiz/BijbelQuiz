const http = require('http');
const fs = require('fs');
const path = require('path');

// Create a simple server to serve the questions API
const server = http.createServer((req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Handle GET requests to /api/questions
  if (req.method === 'GET' && req.url === '/api/questions') {
    try {
      // Get the questions file path
      const questionsPath = path.join(__dirname, '..', '..', 'app', 'assets', 'questions-nl-sv.json');
      
      // Check if file exists
      if (!fs.existsSync(questionsPath)) {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Questions file not found' }));
        return;
      }
      
      // Read the questions file
      const questionsData = fs.readFileSync(questionsPath, 'utf8');
      
      // Return the JSON
      res.writeHead(200);
      res.end(questionsData);
    } catch (error) {
      console.error('Error serving questions:', error);
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Internal server error' }));
    }
  } else {
    // Return 404 for other routes
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not found' }));
  }
});

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});