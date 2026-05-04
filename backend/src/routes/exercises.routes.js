import { Router } from 'express';
import { approveExercise, getExercises, getPublishedExercisesByCourse, publishExercise } from '../services/exercise.service.js';

const router = Router();

router.get('/exercises', async (_req, res) => res.json(await getExercises()));

router.post('/exercises/:id/approve', async (req, res) => {
  const updated = await approveExercise(req.params.id);
  if (!updated) return res.status(404).json({ error: 'Ejercicio no encontrado' });
  res.json(updated);
});

router.post('/exercises/:id/publish', async (req, res) => {
  const updated = await publishExercise(req.params.id);
  if (!updated) return res.status(404).json({ error: 'Ejercicio no encontrado' });
  res.json(updated);
});

router.get('/courses/:courseId/exercises', async (req, res) => {
  res.json(await getPublishedExercisesByCourse(req.params.courseId));
});

export default router;
