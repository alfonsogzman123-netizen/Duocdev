import fs from 'node:fs/promises';
import path from 'node:path';

const exercisesPath = path.resolve(process.cwd(), 'backend/src/data/exercises.json');

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
  const raw = await fs.readFile(exercisesPath, 'utf-8');
  return JSON.parse(raw);
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
  exercises.unshift(...items);
  await writeExercises(exercises);
  return items;
}

export async function approveExercise(id) {
  const exercises = await readExercises();
  const i = exercises.findIndex((e) => e.id === id);
  if (i < 0) return null;
  exercises[i].approved = true;
  await writeExercises(exercises);
  return exercises[i];
}

export async function publishExercise(id) {
  const exercises = await readExercises();
  const i = exercises.findIndex((e) => e.id === id);
  if (i < 0) return null;
  exercises[i].approved = true;
  exercises[i].published = true;
  await writeExercises(exercises);
  return exercises[i];
}

export async function getPublishedExercisesByCourse(courseId) {
  const exercises = await readExercises();
  return exercises.filter((e) => e.courseId === courseId && e.published);
}
