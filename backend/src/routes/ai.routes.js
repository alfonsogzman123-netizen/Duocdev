import { Router } from 'express';

const router = Router();
router.get('/ai/info', (_req, res) => {
  res.json({ message: 'Usa /materials/:id/generate-exercises para generación IA/demo.' });
});

export default router;
