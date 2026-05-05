export function validateMaterialPayload(payload = {}) {
  if (!payload.title?.trim()) return 'title es obligatorio';
  if (!payload.courseId?.trim()) return 'courseId es obligatorio';
  if (!payload.rawText || payload.rawText.trim().length < 100) {
    return 'rawText debe tener al menos 100 caracteres';
  }
  return null;
}

export function validateGenerationPayload(payload = {}) {
  const quantity = Number(payload.quantity ?? 5);
  if (!Number.isInteger(quantity) || quantity < 1 || quantity > 20) {
    return 'quantity debe ser entero entre 1 y 20';
  }
  const allowedDiff = ['basic', 'intermediate', 'advanced'];
  if (!allowedDiff.includes(payload.difficulty)) return 'difficulty inválida';
  if (!payload.type) return 'type es obligatorio';
  return null;
}
