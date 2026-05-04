import { Router } from 'express';
import { createMaterial, getMaterialById, getMaterials } from '../services/material.service.js';
import { saveGeneratedExercises } from '../services/exercise.service.js';
import { generateExercisesFromMaterial } from '../services/openai.service.js';
import { validateGenerationPayload, validateMaterialPayload } from '../utils/validators.js';

const router = Router();

router.get('/materials', async (_req, res) => res.json(await getMaterials()));

router.post('/materials', async (req, res) => {
  const error = validateMaterialPayload(req.body);
  if (error) return res.status(400).json({ error });
  const material = await createMaterial(req.body);
  res.status(201).json(material);
});

router.get('/materials/:id', async (req, res) => {
  const material = await getMaterialById(req.params.id);
  if (!material) return res.status(404).json({ error: 'Material no encontrado' });
  res.json(material);
});

router.post('/materials/:id/generate-exercises', async (req, res) => {
  const payload = {
    quantity: Number(req.body.quantity ?? 5),
    difficulty: req.body.difficulty ?? 'basic',
    type: req.body.type ?? 'multiple_choice',
  };
  const validationError = validateGenerationPayload(payload);
  if (validationError) return res.status(400).json({ error: validationError });

  const material = await getMaterialById(req.params.id);
  if (!material) return res.status(404).json({ error: 'Material no encontrado' });

  const result = await generateExercisesFromMaterial(material, payload);
  const saved = await saveGeneratedExercises(result.exercises);
  res.json({ mode: result.mode, count: saved.length, exercises: saved });
});

export default router;
