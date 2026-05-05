import { saveGeneratedExercises } from '../services/exercise.service.js';
import { createMaterial, getMaterialById, getMaterials } from '../services/material.service.js';
import { generateExercisesFromMaterial } from '../services/openai.service.js';
import { validateGenerationPayload, validateMaterialPayload } from '../utils/validators.js';

export async function listMaterials(_req, res) {
  res.json(await getMaterials());
}

export async function createMaterialController(req, res) {
  const error = validateMaterialPayload(req.body);
  if (error) return res.status(400).json({ error });
  const material = await createMaterial(req.body);
  return res.status(201).json(material);
}

export async function getMaterialController(req, res) {
  const material = await getMaterialById(req.params.id);
  if (!material) return res.status(404).json({ error: 'Material no encontrado' });
  return res.json(material);
}

export async function generateExercisesController(req, res) {
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
  return res.json({ mode: result.mode, count: saved.length, exercises: saved });
}
