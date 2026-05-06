import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const exercisesPath = path.resolve(__dirname, '../data/exercises.json');

async function ensureFile() {
  try {
    await fs.access(exercisesPath);
  } catch (_) {
    await fs.mkdir(path.dirname(exercisesPath), { recursive: true });
    await fs.writeFile(exercisesPath, '[]');
  }
}

async function readExercises() {
  await ensureFile();
  try {
    const raw = await fs.readFile(exercisesPath, 'utf-8');
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (_) {
    await fs.writeFile(exercisesPath, '[]');
    return [];
  }
}

async function writeExercises(exercises) {
  await ensureFile();
  await fs.writeFile(exercisesPath, JSON.stringify(exercises, null, 2));
}

export async function getExercises() {
  return readExercises();
}

export async function saveGeneratedExercises(items) {
  const exercises = await readExercises();
  const next = [...items, ...exercises];
  const deduped = next.filter(
    (exercise, index, list) => list.findIndex((item) => item.id === exercise.id) === index,
  );
  await writeExercises(deduped);
  return items;
}

export async function approveExercise(id) {
  const exercises = await readExercises();
  const index = exercises.findIndex((exercise) => exercise.id === id);
  if (index < 0) return null;
  exercises[index].approved = true;
  await writeExercises(exercises);
  return exercises[index];
}

export async function publishExercise(id) {
  const exercises = await readExercises();
  const index = exercises.findIndex((exercise) => exercise.id === id);
  if (index < 0) return null;
  exercises[index].approved = true;
  exercises[index].published = true;
  await writeExercises(exercises);
  return exercises[index];
}

export async function getPublishedExercisesByCourse(courseId) {
  const exercises = await readExercises();
  return exercises.filter(
    (exercise) => exercise.courseId === courseId && exercise.published,
  );
}
