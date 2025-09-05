import { NextApiRequest, NextApiResponse } from 'next';

// Type definitions for the emergency message
interface EmergencyMessage {
  message: string;
  isBlocking: boolean;
  timestamp: number;
}

interface ApiResponse {
  success?: boolean;
  error?: string;
  message?: string;
  isBlocking?: boolean;
  expiresAt?: number;
}

interface RequestBody {
  message?: string;
  isBlocking?: boolean;
}

// In-memory storage for the emergency message
let emergencyMessage: EmergencyMessage | null = null;

// How long the message should be valid (24 hours)
const MESSAGE_TTL = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

// Extend the NextApiRequest type with necessary properties
type ExtendedNextApiRequest = NextApiRequest & {
  method?: string;
  headers: Record<string, string | string[] | undefined>;
  query: Partial<{
    [key: string]: string | string[];
  }>;
  body: any;
};

// Type for the request handler
type ApiHandler = (
  req: ExtendedNextApiRequest,
  res: NextApiResponse<ApiResponse | string>
) => Promise<void>;

const handler: ApiHandler = async (req, res) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Handle GET requests - used by the client to check for emergency messages
  if (req.method === 'GET') {
    try {
      // If there's no message, return 204 No Content
      if (!emergencyMessage) {
        res.status(204).end();
        return;
      }

      // If the message has expired, clear it and return 204
      const now = Date.now();
      if (now - emergencyMessage.timestamp > MESSAGE_TTL) {
        emergencyMessage = null;
        res.status(204).end();
        return;
      }

      // Otherwise, return the message
      res.status(200).json({
        message: emergencyMessage.message,
        isBlocking: emergencyMessage.isBlocking,
        expiresAt: emergencyMessage.timestamp + MESSAGE_TTL
      });
    } catch (error) {
      console.error('Error handling GET request:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  // Handle POST requests - used by admin to set an emergency message
  if (req.method === 'POST') {
    try {
      // Simple authentication - in production, use a proper auth system
      const authHeader = req.headers.authorization;
      const adminToken = process.env.ADMIN_TOKEN || '';
      
      if (!authHeader || authHeader !== `Bearer ${adminToken}`) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      // Parse and validate request body
      let body: RequestBody;
      try {
        body = typeof req.body === 'string' 
          ? (JSON.parse(req.body) as RequestBody) 
          : (req.body as RequestBody);
      } catch (e) {
        res.status(400).json({ error: 'Invalid JSON body' });
        return;
      }

      const { message, isBlocking = false } = body;

      // Validate the request
      if (!message || typeof message !== 'string') {
        res.status(400).json({ 
          error: 'Message is required and must be a string' 
        });
        return;
      }

      // Set the emergency message
      const timestamp = Date.now();
      emergencyMessage = {
        message: String(message),
        isBlocking: Boolean(isBlocking),
        timestamp
      };

      res.status(200).json({ 
        success: true, 
        expiresAt: timestamp + MESSAGE_TTL 
      });
    } catch (error) {
      console.error('Error handling POST request:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  // Handle DELETE requests - used by admin to clear the emergency message
  if (req.method === 'DELETE') {
    try {
      // Simple authentication
      const authHeader = req.headers.authorization;
      const adminToken = process.env.ADMIN_TOKEN || '';
      
      if (!authHeader || authHeader !== `Bearer ${adminToken}`) {
        res.status(401).json({ error: 'Unauthorized' });
        return;
      }

      emergencyMessage = null;
      res.status(200).json({ success: true });
    } catch (error) {
      console.error('Error handling DELETE request:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  // Return 405 Method Not Allowed for any other methods
  res.setHeader('Allow', ['GET', 'POST', 'DELETE', 'OPTIONS']);
  res.status(405).json({ error: `Method ${req.method} Not Allowed` });
};

// Export the handler for Vercel serverless functions
export default handler;
