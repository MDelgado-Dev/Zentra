import cors from 'cors';
import express from 'express';
import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { genkit } from 'genkit';
import { googleAI } from '@genkit-ai/googleai';

const genkitKey = defineSecret('GEMINI_API_KEY');

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

app.post('/chat', async (req, res) => {
  const message = String(req.body?.message ?? '').trim();
  const locale = String(req.body?.locale ?? 'es');

  if (!message) {
    return res.status(400).json({ reply: 'Missing message.' });
  }

  const ai = genkit({
    plugins: [googleAI({ apiKey: genkitKey.value() })],
    model: googleAI.model('gemini-1.5-flash'),
  });

  const prompt = `Idioma: ${locale}. Responde como asesor financiero. Pregunta: ${message}`;

  try {
    const result = await ai.generate({ prompt });
    return res.json({ reply: result.text });
  } catch (error) {
    return res.status(500).json({ reply: 'Error en IA' });
  }
});

export const chat = onRequest({ secrets: [genkitKey] }, app);
