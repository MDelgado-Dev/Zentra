import 'dotenv/config';

import cors from 'cors';
import express from 'express';
import { genkit } from 'genkit';
import { googleAI } from '@genkit-ai/googleai';

const app = express();
app.use(cors());
app.use(express.json());

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  throw new Error('Missing GEMINI_API_KEY environment variable.');
}

const ai = genkit({
  plugins: [googleAI({ apiKey })],
  model: googleAI.model('gemini-1.5-flash'),
});

app.post('/chat', async (req, res) => {
  const message = String(req.body?.message ?? '').trim();
  const locale = String(req.body?.locale ?? 'es');

  if (!message) {
    return res.status(400).json({ reply: 'Missing message.' });
  }

  const prompt = `Idioma: ${locale}. Responde como asesor financiero. Pregunta: ${message}`;

  try {
    const result = await ai.generate({ prompt });
    return res.json({ reply: result.text });
  } catch (error) {
    return res.status(500).json({ reply: 'Error en IA' });
  }
});

const port = Number(process.env.PORT ?? 3000);
app.listen(port, () => {
  console.log(`Genkit server running on http://localhost:${port}`);
});
