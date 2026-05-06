import 'package:duocdev/models/course_models.dart';

Lesson makeLesson(String id, String title, String content, String code) {
  return Lesson(
    id: id,
    title: title,
    content: content,
    code: code,
    tip:
        'Tip del profesor: practica este concepto con un ejemplo pequeño y explica en voz alta qué ocurre en cada paso.',
    challenge: Challenge(
      question: '¿Cuál es la idea principal de "$title"?',
      options: const [
        'Entender y aplicar el concepto correctamente',
        'Memorizar sin practicar',
        'Evitar escribir código',
        'Ignorar errores',
      ],
      correctIndex: 0,
    ),
  );
}

List<Lesson> lessonsFor(String prefix) => [
  makeLesson(
    '${prefix}1',
    'Fundamentos',
    'Primera base del módulo: reconocer el problema, dividirlo en pasos y probar una solución simple.',
    'print("Hola DuocDev")',
  ),
  makeLesson(
    '${prefix}2',
    'Variables',
    'Guardar datos en memoria para reutilizarlos durante la solución.',
    'x = 10\nnombre = "DuocDev"',
  ),
  makeLesson(
    '${prefix}3',
    'Condiciones',
    'Tomar decisiones según reglas y validar distintos caminos de ejecución.',
    'if x > 5:\n    print("Mayor que cinco")',
  ),
  makeLesson(
    '${prefix}4',
    'Bucles',
    'Repetir tareas automáticamente sin copiar instrucciones una y otra vez.',
    'for i in range(3):\n    print(i)',
  ),
  makeLesson(
    '${prefix}5',
    'Práctica guiada',
    'Combinar fundamentos, variables, condiciones y repetición en un mini reto.',
    'def resolver(numero):\n    return numero > 0',
  ),
];

const emptyLessons = <Lesson>[];

final List<Course> courses = [
  Course(
    id: 'logica',
    title: 'Lógica de Programación',
    level: 'Nivel 1',
    description: 'Pensamiento computacional paso a paso.',
    status: CourseStatus.inProgress,
    lessons: lessonsFor('l'),
  ),
  Course(
    id: 'python',
    title: 'Python',
    level: 'Nivel 2',
    description:
        'Sintaxis clara y productividad para resolver problemas reales.',
    status: CourseStatus.available,
    lessons: lessonsFor('p'),
  ),
  Course(
    id: 'git',
    title: 'Git y GitHub',
    level: 'Nivel 3',
    description: 'Versionado, historial y colaboración profesional.',
    status: CourseStatus.available,
    lessons: lessonsFor('g'),
  ),
  Course(
    id: 'web',
    title: 'Desarrollo Web',
    level: 'Nivel 4',
    description: 'HTML, CSS y JavaScript moderno para interfaces funcionales.',
    status: CourseStatus.available,
    lessons: lessonsFor('w'),
  ),
  Course(
    id: 'java',
    title: 'Java',
    level: 'Nivel 5',
    description: 'Programación orientada a objetos y buenas prácticas.',
    status: CourseStatus.available,
    lessons: lessonsFor('j'),
  ),
  Course(
    id: 'sql',
    title: 'SQL',
    level: 'Nivel 6',
    description: 'Consultas, relaciones y análisis de datos.',
    status: CourseStatus.available,
    lessons: lessonsFor('s'),
  ),
  const Course(
    id: 'cpp',
    title: 'C++ (Próximamente)',
    level: 'Nivel 7',
    description: 'Curso en preparación.',
    status: CourseStatus.locked,
    lessons: emptyLessons,
  ),
];
