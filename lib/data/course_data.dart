import 'package:duocdev/models/course_models.dart';

Lesson makeLesson(String id, String title, String content, String code) {
  return Lesson(
    id: id,
    title: title,
    content: content,
    code: code,
    tip: 'Tip: practica este concepto con ejemplos pequeños por 10 minutos.',
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

List<Lesson> lessonsFor(String p) => [
      makeLesson('${p}1', 'Fundamentos', 'Primera base del módulo.', 'print("Hola DuocDev")'),
      makeLesson('${p}2', 'Variables', 'Guardar datos en memoria.', 'x = 10'),
      makeLesson('${p}3', 'Condiciones', 'Tomar decisiones según reglas.', 'if x > 5:\n    print(x)'),
      makeLesson('${p}4', 'Bucles', 'Repetir tareas automáticamente.', 'for i in range(3):\n    print(i)'),
      makeLesson('${p}5', 'Práctica guiada', 'Combinar todo en un mini ejercicio.', 'def resolver():\n    return True'),
    ];

const emptyLessons = <Lesson>[];

final List<Course> courses = [
  Course(id: 'logica', title: 'Lógica de Programación', level: 'Nivel 1', description: 'Pensamiento computacional paso a paso.', status: CourseStatus.inProgress, lessons: lessonsFor('l')),
  Course(id: 'python', title: 'Python', level: 'Nivel 2', description: 'Sintaxis clara y productividad.', status: CourseStatus.available, lessons: lessonsFor('p')),
  Course(id: 'git', title: 'Git y GitHub', level: 'Nivel 3', description: 'Versionado y colaboración profesional.', status: CourseStatus.available, lessons: lessonsFor('g')),
  Course(id: 'web', title: 'Desarrollo Web', level: 'Nivel 4', description: 'HTML, CSS y JavaScript moderno.', status: CourseStatus.available, lessons: lessonsFor('w')),
  Course(id: 'java', title: 'Java', level: 'Nivel 5', description: 'POO y buenas prácticas.', status: CourseStatus.available, lessons: lessonsFor('j')),
  Course(id: 'sql', title: 'SQL', level: 'Nivel 6', description: 'Consultas y análisis de datos.', status: CourseStatus.available, lessons: lessonsFor('s')),
  const Course(id: 'cpp', title: 'C++ (Próximamente)', level: 'Nivel 7', description: 'Curso en preparación.', status: CourseStatus.locked, lessons: emptyLessons),
];
