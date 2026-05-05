import { config } from 'dotenv';
config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY?.trim();

function demoGenerate(material, { quantity, difficulty, type }) {
  const tokens = material.rawText.split(/\s+/).filter((w) => w.length > 4);
  return Array.from({ length: quantity }, (_, i) => {
    const t = tokens[i % Math.max(tokens.length, 1)] ?? 'concepto';
    return {
      id: `ex_${Date.now()}_${i}`,
      materialId: material.id,
      courseId: material.courseId,
      type,
      difficulty,
      question: `Según el material, ¿qué opción describe mejor "${t}"?`,
      options: ['Concepto central del material', 'Tema fuera del material', 'Error de sintaxis obligatorio', 'Comando no existente'],
      correctIndex: 0,
      explanation: 'La alternativa 1 resume la idea principal del contenido entregado por el profesor.',
      xpReward: 20,
      approved: false,
      published: false,
      createdAt: new Date().toISOString(),
    };
  });
}

export async function generateExercisesFromMaterial(material, options) {
  if (!OPENAI_API_KEY) return { mode: 'demo', exercises: demoGenerate(material, options) };

  try {
    const prompt = `Genera ${options.quantity} ejercicios tipo ${options.type} dificultad ${options.difficulty} basados SOLO en este material:\n${material.rawText}`;
    const response = await fetch('https://api.openai.com/v1/responses', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4.1-mini',
        input: [
          { role: 'system', content: 'Devuelve JSON array con ejercicios estructurados, 4 opciones y correctIndex.' },
          { role: 'user', content: prompt },
        ],
      }),
    });
    if (!response.ok) throw new Error(`OpenAI ${response.status}`);
    const data = await response.json();
    const output = data.output_text ?? '[]';
    const parsed = JSON.parse(output);
    const exercises = parsed.map((e, i) => ({
      id: `ex_${Date.now()}_${i}`,
      materialId: material.id,
      courseId: material.courseId,
      type: e.type ?? options.type,
      difficulty: e.difficulty ?? options.difficulty,
      question: e.question,
      options: e.options,
      correctIndex: e.correctIndex ?? 0,
      explanation: e.explanation ?? 'Sin explicación',
      xpReward: e.xpReward ?? 20,
      approved: false,
      published: false,
      createdAt: new Date().toISOString(),
    }));
    return { mode: 'openai', exercises };
  } catch {
    return { mode: 'demo_fallback', exercises: demoGenerate(material, options) };
  }
}
