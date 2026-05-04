import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import aiRoutes from './routes/ai.routes.js';
import exercisesRoutes from './routes/exercises.routes.js';
import healthRoutes from './routes/health.routes.js';
import materialsRoutes from './routes/materials.routes.js';

dotenv.config();

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(healthRoutes);
app.use(materialsRoutes);
app.use(exercisesRoutes);
app.use(aiRoutes);

app.listen(port, () => {
  console.log(`DuocDev Backend running on http://localhost:${port}`);
});
