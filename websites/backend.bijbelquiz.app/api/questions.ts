import { NextApiRequest, NextApiResponse } from 'next';
import fs from 'fs';
import path from 'path';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  
  // Log incoming requests
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url} from ${req.headers['x-forwarded-for'] || req.socket.remoteAddress}`);
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    console.log(`[${new Date().toISOString()}] CORS preflight request handled`);
    res.status(200).end();
    return;
  }

  // Handle GET requests
  if (req.method === 'GET') {
    try {
      // Get the questions file path
      const questionsPath = path.join(process.cwd(), '..', 'app', 'assets', 'questions-nl-sv.json');
      
      console.log(`[${new Date().toISOString()}] Attempting to read questions from: ${questionsPath}`);
      
      // Check if file exists
      if (!fs.existsSync(questionsPath)) {
        console.error(`[${new Date().toISOString()}] Questions file not found at: ${questionsPath}`);
        res.status(404).json({ error: 'Questions file not found' });
        return;
      }
      
      // Get file stats for logging
      const stats = fs.statSync(questionsPath);
      console.log(`[${new Date().toISOString()}] Questions file found. Size: ${stats.size} bytes, Modified: ${stats.mtime.toISOString()}`);
      
      // Read the questions file
      const questionsData = fs.readFileSync(questionsPath, 'utf8');
      
      // Parse and return the JSON
      const questions = JSON.parse(questionsData);
      console.log(`[${new Date().toISOString()}] Successfully parsed ${Array.isArray(questions) ? questions.length : 'unknown'} questions`);
      
      res.status(200).json(questions);
    } catch (error) {
      console.error(`[${new Date().toISOString()}] Error serving questions:`, error);
      res.status(500).json({ error: 'Internal server error' });
    }
  } else {
    // Return 405 Method Not Allowed for any other methods
    const allowedMethods = ['GET', 'OPTIONS'];
    console.warn(`[${new Date().toISOString()}] Method ${req.method} not allowed. Allowed methods: ${allowedMethods.join(', ')}`);
    res.setHeader('Allow', allowedMethods);
    res.status(405).json({ error: `Method ${req.method} Not Allowed` });
  }
}