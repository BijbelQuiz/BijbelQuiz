import { NextApiRequest, NextApiResponse } from 'next';

// Map of platforms to their file names and content types
const PLATFORM_FILES = {
  android: {
    filename: 'bijbelquiz-android.apk',
    contentType: 'application/vnd.android.package-archive',
    path: '/downloads/bijbelquiz-android.apk'
  },
  linux: {
    filename: 'bijbelquiz-linux.AppImage',
    contentType: 'application/octet-stream',
    path: '/downloads/bijbelquiz-linux.AppImage'
  },
  // Add other platforms as needed
} as const;

type Platform = keyof typeof PLATFORM_FILES;

// Helper function to check if a string is a valid platform
function isPlatform(value: string): value is Platform {
  return value in PLATFORM_FILES;
}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET', 'OPTIONS']);
    return res.status(405).json({ error: `Method ${req.method} Not Allowed` });
  }

  try {
    const platform = (req.query.platform || 'android') as string;
    
    // Validate platform
    if (!isPlatform(platform)) {
      return res.status(400).json({ 
        error: 'Invalid platform',
        validPlatforms: Object.keys(PLATFORM_FILES)
      });
    }

    const { filename, contentType } = PLATFORM_FILES[platform];
    
    // Redirect to the file in the public directory
    // Use the correct path that we know works
    return res.redirect(307, `/downloads/${filename}`);
    
  } catch (error) {
    console.error('Download error:', error);
    return res.status(500).json({ 
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
}