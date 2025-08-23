import { NextApiRequest, NextApiResponse } from 'next';
import { readFileSync } from 'fs';
import { join } from 'path';

// Map of platforms to their file names and content types
const PLATFORM_FILES = {
  android: {
    filename: 'bijbelquiz-android.apk',
    contentType: 'application/vnd.android.package-archive',
    path: 'public/downloads/bijbelquiz-android.apk'
  },
  linux: {
    filename: 'bijbelquiz-linux.AppImage',
    contentType: 'application/octet-stream',
    path: 'public/downloads/bijbelquiz-linux.AppImage'
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

    const { filename, contentType, path } = PLATFORM_FILES[platform];
    
    try {
      // Read the file directly from the file system
      const filePath = join(process.cwd(), path);
      const fileContent = readFileSync(filePath);
      
      // Set the appropriate headers
      res.setHeader('Content-Type', contentType);
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      res.setHeader('Content-Length', fileContent.length);
      
      // Send the file content
      return res.status(200).send(fileContent);
      
    } catch (error) {
      console.error('Error serving file:', error);
      return res.status(500).json({ 
        error: 'Failed to serve file',
        message: error instanceof Error ? error.message : 'Unknown error'
      });
    }
    
  } catch (error) {
    console.error('Download error:', error);
    return res.status(500).json({ 
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
}