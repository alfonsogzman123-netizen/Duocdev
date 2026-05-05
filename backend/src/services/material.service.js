import fs from 'fs/promises';
import path from 'path';

const dataDir = path.join(process.cwd(), 'src', 'data');
const materialsPath = path.join(dataDir, 'materials.json');

async function readMaterials() {
  const raw = await fs.readFile(materialsPath, 'utf-8');
  return JSON.parse(raw);
}

async function writeMaterials(materials) {
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
