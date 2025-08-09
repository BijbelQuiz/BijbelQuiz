// Vercel Serverless Function: activation-codes API (clean path)
// Route: /api/activation-codes
// Provides simple activation code verification with CORS

const CODES = [
  'BIJBEL2025',
  'QUIZ1234',
  'TESTCODE',
  'DEMO-0000-2025',
];

function setCors(res: any, origin: string | undefined) {
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  // Allow all origins; restrict to your domain if needed
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Vary', 'Origin');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, X-Requested-With');
}

export default function handler(req: any, res: any) {
  setCors(res, req.headers?.origin as string | undefined);

  if (req.method === 'OPTIONS') {
    res.status(204).end();
    return;
  }

  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method Not Allowed' });
    return;
  }

  const raw = req.query?.code;
  const codeToCheck = Array.isArray(raw)
    ? raw[0]
    : typeof raw === 'string'
    ? raw
    : '';
  const normalized = (codeToCheck || '').trim().toUpperCase();

  if (normalized) {
    const valid = CODES.includes(normalized);
    res.status(200).json({ valid });
    return;
  }

  // Return list for debugging if no code was provided
  res.status(200).json({ codes: CODES });
}
