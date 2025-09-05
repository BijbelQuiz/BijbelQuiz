import { NextApiRequest, NextApiResponse } from 'next';

// Type definitions
interface VersionInfo {
  version: string;
  releaseNotes: string;
  downloadEndpoint: string;
  platform: string;
  currentVersion?: string;
  [key: string]: string | undefined;  // Add index signature to allow dynamic property access
}

interface PlatformVersions {
  android: VersionInfo;
  ios: VersionInfo;
  windows: VersionInfo;
  macos: VersionInfo;
  linux: VersionInfo;
  web: VersionInfo;
}

// Version information - in a real app, this might come from a database
const versions: PlatformVersions = {
  android: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=android",
    platform: "android"
  },
  ios: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=ios",
    platform: "ios"
  },
  windows: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=windows",
    platform: "windows"
  },
  macos: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=macos",
    platform: "macos"
  },
  linux: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=linux",
    platform: "linux"
  },
  web: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes",
    downloadEndpoint: "/api/download?platform=web",
    platform: "web"
  }
};

// Test versions - used for local development testing
const testVersions: PlatformVersions = {
  android: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=android",
    platform: "android"
  },
  ios: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=ios",
    platform: "ios"
  },
  windows: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=windows",
    platform: "windows"
  },
  macos: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=macos",
    platform: "macos"
  },
  linux: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=linux",
    platform: "linux"
  },
  web: {
    version: "1.1.0",
    releaseNotes: "• Nieuwe vragen toegevoegd\n• Prestatieverbeteringen\n• Bug fixes\n• Nieuwe functies",
    downloadEndpoint: "/api/download?platform=web",
    platform: "web"
  }
};

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  
  // Handle OPTIONS method for CORS preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Handle GET requests
  if (req.method === 'GET') {
    try {
      const platform = req.query.platform as string || 'android';
      // Check if we're in test mode (for local development)
      const testMode = req.query.test === 'true' || req.headers.host?.includes('localhost');
      
      // Validate platform
      if (!versions.hasOwnProperty(platform)) {
        res.status(400).json({ error: 'Invalid platform' });
        return;
      }
      
      // Get version info for the requested platform
      const baseVersionData = testMode ? testVersions[platform as keyof PlatformVersions] : versions[platform as keyof PlatformVersions];
      
      // Include platform and current version in response
      const currentVersion = req.query.currentVersion as string || null;
      const versionData = {
        ...baseVersionData,
        platform: platform,
        currentVersion: currentVersion
      };
      
      res.status(200).json(versionData);
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