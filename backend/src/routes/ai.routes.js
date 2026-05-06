import { Router } from 'express';
import { askTutorController, getAiInfo } from '../controllers/ai.controller.js';

const router = Router();
router.get('/ai/info', getAiInfo);
router.post('/ai/tutor', askTutorController);

export default router;
