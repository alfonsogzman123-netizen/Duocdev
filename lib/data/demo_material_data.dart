import 'package:duocdev/models/academic_material.dart';

final demoMaterials = [
  AcademicMaterial(
    id: 'mat_py',
    title: 'Variables y condicionales en Python',
    subject: 'Python',
    courseId: 'python',
    unitName: 'Fundamentos',
    teacherName: 'Profesor DuocDev',
    createdAt: DateTime(2026, 5, 2),
    sourceType: MaterialSourceType.text,
    rawText:
        'Las variables guardan datos. if, elif y else permiten tomar decisiones según condiciones verdaderas o falsas.',
    summary: 'Variables, condicionales y toma de decisiones en Python.',
    tags: ['python', 'variables', 'if'],
    status: MaterialStatus.processed,
  ),
  AcademicMaterial(
    id: 'mat_git',
    title: 'Introducción a Git y commits',
    subject: 'Git y GitHub',
    courseId: 'git',
    unitName: 'Control de versiones',
    teacherName: 'Profesor DuocDev',
    createdAt: DateTime(2026, 5, 1),
    sourceType: MaterialSourceType.text,
    rawText:
        'Git permite versionar código. git add prepara cambios y git commit guarda un hito con mensaje e historial.',
    summary: 'Comandos base para registrar cambios con Git.',
    tags: ['git', 'commit'],
    status: MaterialStatus.processed,
  ),
];
