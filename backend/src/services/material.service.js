import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const materialsPath = path.resolve(__dirname, '../data/materials.json');

async function ensureFile() {
  try {
    await fs.access(materialsPath);
  } catch (_) {
    await fs.mkdir(path.dirname(materialsPath), { recursive: true });
    await fs.writeFile(materialsPath, '[]');
  }
}

async function readMaterials() {
  await ensureFile();
  const raw = await fs.readFile(materialsPath, 'utf-8');
  return JSON.parse(raw);
}

async function writeMaterials(materials) {
  await ensureFile();
  await fs.writeFile(materialsPath, JSON.stringify(materials, null, 2));
}

export async function getMaterials() {
  return readMaterials();
}

export async function getMaterialById(id) {
  const materials = await readMaterials();
  return materials.find((m) => m.id === id);
}

export async function createMaterial(payload) {
  const materials = await readMaterials();
  const material = {
    id: `mat_${Date.now()}`,
    title: payload.title.trim(),
    courseId: payload.courseId.trim(),
    unitName: payload.unitName?.trim() || 'Unidad general',
    teacherName: payload.teacherName?.trim() || 'Profesor DuocDev',
    rawText: payload.rawText.trim(),
    tags: Array.isArray(payload.tags) ? payload.tags : [],
    createdAt: new Date().toISOString(),
  };
  materials.unshift(material);
  await writeMaterials(materials);
  return material;
}
