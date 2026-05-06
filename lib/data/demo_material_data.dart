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
  AcademicMaterial(
    id: 'mat_web',
    title: 'HTML, CSS y JavaScript inicial',
    subject: 'Desarrollo Web',
    courseId: 'web',
    unitName: 'Frontend base',
    teacherName: 'Profesor DuocDev',
    createdAt: DateTime(2026, 5, 1),
    sourceType: MaterialSourceType.text,
    rawText:
        'HTML define estructura, CSS presenta visualmente la interfaz y JavaScript agrega interacción para responder a eventos del usuario.',
    summary: 'Roles principales de HTML, CSS y JavaScript.',
    tags: ['html', 'css', 'javascript'],
    status: MaterialStatus.processed,
  ),
  AcademicMaterial(
    id: 'mat_sql',
    title: 'Consultas SELECT con filtros',
    subject: 'SQL',
    courseId: 'sql',
    unitName: 'Consultas básicas',
    teacherName: 'Profesor DuocDev',
    createdAt: DateTime(2026, 4, 30),
    sourceType: MaterialSourceType.text,
    rawText:
        'SELECT obtiene columnas desde una tabla. WHERE filtra registros según condiciones y ORDER BY ordena los resultados.',
    summary: 'Consulta, filtro y ordenamiento de datos en SQL.',
    tags: ['sql', 'select', 'where'],
    status: MaterialStatus.processed,
  ),
];
