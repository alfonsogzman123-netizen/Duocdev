import { config } from 'dotenv';

config();

const OPENAI_API_KEY = process.env.OPENAI_API_KEY?.trim();

const tutorSystemPrompt =
  'Eres Tutor IA de DuocDev. Responde en español claro, breve y pedagógico. Usa ejemplos simples, pistas y una mini pregunta de práctica cuando aporte valor. No inventes datos fuera del contexto académico entregado.';

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
      options: [
        'Concepto central del material',
        'Tema fuera del material',
        'Error de sintaxis obligatorio',
        'Comando no existente',
      ],
      correctIndex: 0,
      explanation:
        'La alternativa 1 resume la idea principal del contenido entregado por el profesor.',
      xpReward:
        difficulty === 'advanced' ? 40 : difficulty === 'intermediate' ? 30 : 20,
      approved: false,
      published: false,
      sourceReference: material.title,
      createdAt: new Date().toISOString(),
    };
  });
}

function demoTutorAnswer({ question, context }) {
  const shortContext = context.length > 220 ? `${context.slice(0, 220)}...` : context;
  return {
    mode: OPENAI_API_KEY ? 'demo_fallback' : 'demo',
    answer:
      `Contexto usado: ${shortContext}\n\n` +
      `Para resolver "${question}", empieza identificando el concepto principal, escribe un ejemplo pequeño y prueba un caso límite. ` +
      'Mini práctica: explica con tus palabras qué entrada recibe el código, qué proceso realiza y qué salida esperas.',
  };
}

export async function generateExercisesFromMaterial(material, options) {
  if (!OPENAI_API_KEY) {
    return { mode: 'demo', exercises: demoGenerate(material, options) };
  }

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
          {
            role: 'system',
            content:
              'Devuelve JSON array con ejercicios estructurados, 4 opciones y correctIndex. Todo el texto debe estar en español.',
          },
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

export async function answerTutorQuestion({ question, context }) {
  if (!OPENAI_API_KEY) return demoTutorAnswer({ question, context });

  try {
    const response = await fetch('https://api.openai.com/v1/responses', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4.1-mini',
        input: [
          { role: 'system', content: tutorSystemPrompt },
          { role: 'user', content: `Contexto: ${context}\nPregunta: ${question}` },
        ],
      }),
    });
    if (!response.ok) throw new Error(`OpenAI ${response.status}`);

    const data = await response.json();
    const answer = data.output_text;
    if (typeof answer === 'string' && answer.trim()) {
      return { mode: 'openai', answer: answer.trim() };
    }
    return demoTutorAnswer({ question, context });
  } catch {
    return demoTutorAnswer({ question, context });
  }
}
