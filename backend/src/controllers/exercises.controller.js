import { approveExercise, getExercises, getPublishedExercisesByCourse, publishExercise } from '../services/exercise.service.js';

export async function listExercises(_req, res) {
  res.json(await getExercises());
}

export async function approveExerciseController(req, res) {
  const updated = await approveExercise(req.params.id);
  if (!updated) return res.status(404).json({ error: 'Ejercicio no encontrado' });
  return res.json(updated);
}

export async function publishExerciseController(req, res) {
  const updated = await publishExercise(req.params.id);
  if (!updated) return res.status(404).json({ error: 'Ejercicio no encontrado' });
  return res.json(updated);
}

export async function listPublishedByCourse(req, res) {
  res.json(await getPublishedExercisesByCourse(req.params.courseId));
}
