import cors from 'cors';
import express from 'express';
import { env } from './config/env.js';
import aiRoutes from './routes/ai.routes.js';
import exercisesRoutes from './routes/exercises.routes.js';
import healthRoutes from './routes/health.routes.js';
import materialsRoutes from './routes/materials.routes.js';

const app = express();

app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(healthRoutes);
app.use(materialsRoutes);
app.use(exercisesRoutes);
app.use(aiRoutes);

app.use((_req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Error interno del backend' });
});

app.listen(env.port, () => {
  console.log(`DuocDev Backend running on http://localhost:${env.port}`);
});
