import { config } from 'dotenv';

config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY?.trim();

function demoGenerate(material, { quantity, difficulty, type }) {
  const tokens = material.rawText.split(/\s+/).filter((word) => word.length > 4);
  return Array.from({ length: quantity }, (_, index) => {
    const token = tokens[index % Math.max(tokens.length, 1)] ?? 'concepto';
    return {
      id: `ex_${Date.now()}_${index}`,
      materialId: material.id,
      courseId: material.courseId,
      type,
      difficulty,
      question: `Según el material, ¿qué opción describe mejor "${token}"?`,
      options: ['Concepto central del material', 'Tema fuera del material', 'Error de sintaxis obligatorio', 'Comando no existente'],
      correctIndex: 0,
      explanation: 'La alternativa 1 resume la idea principal del contenido entregado por el profesor.',
      xpReward: 20,
      approved: false,
      published: false,
      sourceReference: material.title,
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
    const exercises = parsed.map((exercise, index) => ({
      id: `ex_${Date.now()}_${index}`,
      materialId: material.id,
      courseId: material.courseId,
      type: exercise.type ?? options.type,
      difficulty: exercise.difficulty ?? options.difficulty,
      question: exercise.question,
      options: exercise.options,
      correctIndex: exercise.correctIndex ?? 0,
      explanation: exercise.explanation ?? 'Sin explicación',
      xpReward: exercise.xpReward ?? 20,
      approved: false,
      published: false,
      sourceReference: material.title,
      createdAt: new Date().toISOString(),
    }));
    return { mode: 'openai', exercises };
  } catch {
    return { mode: 'demo_fallback', exercises: demoGenerate(material, options) };
  }
}
