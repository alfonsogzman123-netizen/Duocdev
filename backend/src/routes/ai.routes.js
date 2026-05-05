import { Router } from 'express';
import { getAiInfo } from '../controllers/ai.controller.js';

const router = Router();
router.get('/ai/info', getAiInfo);

export default router;
