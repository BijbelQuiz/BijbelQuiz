import { NextApiRequest, NextApiResponse } from 'next';

// Map of platforms to their file names
const PLATFORM_FILES: Record<string, string> = {
  android: 'bijbelquiz-android.apk',
  ios: 'bijbelquiz-ios.ipa',
  windows: 'bijbelquiz-windows.exe',
  macos: 'bijbelquiz-macos.dmg',
  linux: 'bijbelquiz-linux.AppImage',
  web: 'bijbelquiz-web.zip'
};

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Handle GET requests
  if (req.method === 'GET') {
    try {
      const platform = req.query.platform as string || 'android';
      
      // Validate platform
      if (!PLATFORM_FILES.hasOwnProperty(platform)) {
        res.status(400).json({ error: 'Invalid platform' });
        return;
      }
      
      // Get the file name for this platform
      const fileName = PLATFORM_FILES[platform];
      
      // Redirect to the public URL for better performance and reliability
      res.redirect(302, `/downloads/${fileName}`);
    } catch (error) {
      console.error('Error handling GET request:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  } else {
    // Return 405 Method Not Allowed for any other methods
    res.setHeader('Allow', ['GET', 'OPTIONS']);
    res.status(405).json({ error: `Method ${req.method} Not Allowed` });
  }
}