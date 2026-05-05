import { Router } from 'express';
import { createMaterialController, generateExercisesController, getMaterialController, listMaterials } from '../controllers/materials.controller.js';

const router = Router();
router.get('/materials', listMaterials);
router.post('/materials', createMaterialController);
router.get('/materials/:id', getMaterialController);
router.post('/materials/:id/generate-exercises', generateExercisesController);

export default router;
