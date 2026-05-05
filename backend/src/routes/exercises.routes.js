import { Router } from 'express';
import { approveExerciseController, listExercises, listPublishedByCourse, publishExerciseController } from '../controllers/exercises.controller.js';

const router = Router();
router.get('/exercises', listExercises);
router.post('/exercises/:id/approve', approveExerciseController);
router.post('/exercises/:id/publish', publishExerciseController);
router.get('/courses/:courseId/exercises', listPublishedByCourse);

export default router;
