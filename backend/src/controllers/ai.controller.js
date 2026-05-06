import { answerTutorQuestion } from '../services/openai.service.js';

export function getAiInfo(_req, res) {
  res.json({
    service: 'Tutor IA DuocDev',
    message:
      'Usa POST /ai/tutor para preguntas demo/API y /materials/:id/generate-exercises para ejercicios.',
  });
}

export async function askTutorController(req, res) {
  const question = req.body?.question?.trim();
  const context = req.body?.context?.trim() || 'Pregunta general de programación.';

  if (!question) {
    return res.status(400).json({ error: 'question es obligatorio' });
  }

  const result = await answerTutorQuestion({ question, context });
  return res.json(result);
}
