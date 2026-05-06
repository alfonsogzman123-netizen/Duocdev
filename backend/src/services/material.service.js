import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const materialsPath = path.resolve(__dirname, '../data/materials.json');

const courseNames = {
  logica: 'Lógica de Programación',
  python: 'Python Básico',
  git: 'Git y GitHub',
  web: 'Desarrollo Web',
  java: 'Java',
  sql: 'SQL',
  cpp: 'C++',
};

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
  try {
    const raw = await fs.readFile(materialsPath, 'utf-8');
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (_) {
    await fs.writeFile(materialsPath, '[]');
    return [];
  }
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
  return materials.find((material) => material.id === id);
}

export async function createMaterial(payload) {
  const materials = await readMaterials();
  const courseId = payload.courseId.trim();
  const material = {
    id:
      typeof payload.id === 'string' && payload.id.trim()
        ? payload.id.trim()
        : `mat_${Date.now()}`,
    title: payload.title.trim(),
    subject: payload.subject?.trim() || courseNames[courseId] || courseId,
    courseId,
    unitName: payload.unitName?.trim() || 'Unidad general',
    teacherName: payload.teacherName?.trim() || 'Profesor DuocDev',
    rawText: payload.rawText.trim(),
    tags: Array.isArray(payload.tags)
      ? payload.tags.map((tag) => String(tag).trim()).filter(Boolean)
      : [],
    createdAt: payload.createdAt || new Date().toISOString(),
  };

  const existingIndex = materials.findIndex((item) => item.id === material.id);
  if (existingIndex >= 0) {
    materials[existingIndex] = { ...materials[existingIndex], ...material };
  } else {
    materials.unshift(material);
  }

  await writeMaterials(materials);
  return material;
}
