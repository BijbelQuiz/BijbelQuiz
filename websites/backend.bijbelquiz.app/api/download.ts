import { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Get query parameters for platform and version
  const { platform, currentVersion } = req.query;

  // Build the download page URL with parameters
  const baseUrl = 'https://bijbelquiz.app/download.html';
  const params = new URLSearchParams();

  if (platform) params.append('platform', platform as string);
  if (currentVersion) params.append('current', currentVersion as string);

  const redirectUrl = params.toString() ? `${baseUrl}?${params.toString()}` : baseUrl;

  // Redirect to the unified download page
  res.setHeader('X-Deprecated', 'true');
  res.redirect(302, redirectUrl);
}