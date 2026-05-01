import 'package:duocdev/models/course_models.dart';

const List<Course> courses = [
  Course(
    id: 'logica',
    title: 'Lógica de Programación',
    level: 'Nivel 1',
    description: 'Pseudocódigo, variables, condiciones y ciclos',
    lessons: [
      Lesson(id: 'l1', title: 'Introducción a la lógica', content: 'La lógica ayuda a resolver problemas paso a paso.', code: 'INICIO\n  leer problema\n  dividir en pasos\nFIN', challenge: Challenge(question: '¿Cuál es el objetivo de la lógica?', options: ['Resolver problemas ordenadamente', 'Solo escribir código rápido', 'Evitar pruebas', 'Usar internet siempre'], correctIndex: 0)),
      Lesson(id: 'l2', title: 'Variables y datos', content: 'Las variables guardan información que puede cambiar.', code: 'edad <- 18\nnombre <- "Ana"', challenge: Challenge(question: '¿Qué guarda una variable?', options: ['Información', 'Pantallas', 'Teclados', 'Errores'], correctIndex: 0)),
      Lesson(id: 'l3', title: 'Condicionales', content: 'Permiten tomar decisiones según condiciones.', code: 'SI nota >= 4 ENTONCES\n  mostrar "Aprobado"\nFIN SI', challenge: Challenge(question: 'Un condicional sirve para...', options: ['Tomar decisiones', 'Dibujar', 'Apagar PC', 'Instalar apps'], correctIndex: 0)),
    ],
  ),
  Course(id: 'python', title: 'Python', level: 'Nivel 2', description: 'Fundamentos de programación en Python', lessons: [
    Lesson(id: 'p1', title: '¿Qué es Python?', content: 'Python es un lenguaje simple y poderoso.', code: 'print("Hola DuocDev")', challenge: Challenge(question: 'Python se usa para...', options: ['Desarrollo y automatización', 'Solo juegos retro', 'Diseño 3D únicamente', 'Nada educativo'], correctIndex: 0)),
    Lesson(id: 'p2', title: 'Variables en Python', content: 'Se crean sin declarar tipo explícitamente.', code: 'nombre = "Leo"\nedad = 19', challenge: Challenge(question: '¿Para qué sirve una variable?', options: ['Guardar información', 'Reiniciar internet', 'Compilar Java', 'Editar fotos'], correctIndex: 0)),
    Lesson(id: 'p3', title: 'Funciones', content: 'Permiten reutilizar bloques de código.', code: 'def saludar(nombre):\n    return f"Hola {nombre}"', challenge: Challenge(question: 'Una función ayuda a...', options: ['Reutilizar código', 'Borrar sistema', 'Cambiar hardware', 'Desinstalar Python'], correctIndex: 0)),
  ]),
  Course(id: 'git', title: 'Git y GitHub', level: 'Nivel 3', description: 'Control de versiones y colaboración', lessons: [
    Lesson(id: 'g1', title: '¿Qué es Git?', content: 'Git registra cambios y facilita colaboración.', code: 'git init\ngit status', challenge: Challenge(question: 'Git permite...', options: ['Controlar versiones', 'Diseñar logos', 'Editar audio', 'Renderizar video'], correctIndex: 0)),
    Lesson(id: 'g2', title: 'Commits', content: 'Un commit guarda un estado de tu proyecto.', code: 'git add .\ngit commit -m "avance"', challenge: Challenge(question: 'Un commit es...', options: ['Un registro de cambios', 'Una carpeta vacía', 'Una rama remota', 'Un error'], correctIndex: 0)),
    Lesson(id: 'g3', title: 'Push y pull', content: 'Push sube cambios y pull los descarga.', code: 'git push origin main\ngit pull origin main', challenge: Challenge(question: 'git pull sirve para...', options: ['Traer cambios remotos', 'Eliminar repositorio', 'Cerrar GitHub', 'Crear imagen'], correctIndex: 0)),
  ]),
  Course(id: 'web', title: 'Desarrollo Web', level: 'Nivel 4', description: 'HTML, CSS y JavaScript', lessons: [
    Lesson(id: 'w1', title: 'HTML base', content: 'HTML estructura el contenido de una web.', code: '<h1>Hola</h1>', challenge: Challenge(question: 'HTML se usa para...', options: ['Estructurar contenido', 'Diseñar bases de datos', 'Compilar apps nativas', 'Gestionar servidores'], correctIndex: 0)),
    Lesson(id: 'w2', title: 'CSS básico', content: 'CSS da estilo visual a la web.', code: 'h1 { color: cyan; }', challenge: Challenge(question: 'CSS permite...', options: ['Aplicar estilos', 'Controlar Git', 'Ejecutar SQL', 'Crear APK'], correctIndex: 0)),
    Lesson(id: 'w3', title: 'JS inicial', content: 'JavaScript agrega interacción.', code: 'console.log("click")', challenge: Challenge(question: 'JavaScript agrega...', options: ['Interactividad', 'Solo tipografías', 'Solo tablas', 'Solo rutas'], correctIndex: 0)),
  ]),
  Course(id: 'java', title: 'Java', level: 'Nivel 5', description: 'POO y bases del lenguaje Java', lessons: [
    Lesson(id: 'j1', title: 'Introducción a Java', content: 'Java es orientado a objetos y multiplataforma.', code: 'System.out.println("Hola");', challenge: Challenge(question: 'Java es...', options: ['Orientado a objetos', 'Un navegador', 'Un DBMS', 'Un editor'], correctIndex: 0)),
    Lesson(id: 'j2', title: 'Clases y objetos', content: 'Las clases definen objetos con atributos.', code: 'class Auto { String marca; }', challenge: Challenge(question: 'Una clase representa...', options: ['Un molde de objetos', 'Un archivo temporal', 'Un bug', 'Un servidor'], correctIndex: 0)),
    Lesson(id: 'j3', title: 'Condicionales y ciclos', content: 'Controlan flujo del programa.', code: 'if (x > 0) { System.out.println(x); }', challenge: Challenge(question: 'if en Java sirve para...', options: ['Tomar decisiones', 'Hacer merge', 'Compilar Flutter', 'Ejecutar SQL'], correctIndex: 0)),
  ]),
  Course(id: 'sql', title: 'SQL', level: 'Nivel 6', description: 'Consultas y manipulación de datos', lessons: [
    Lesson(id: 's1', title: 'SELECT básico', content: 'SELECT consulta datos de una tabla.', code: 'SELECT * FROM estudiantes;', challenge: Challenge(question: 'SELECT se usa para...', options: ['Consultar datos', 'Borrar app', 'Compilar Java', 'Subir commits'], correctIndex: 0)),
    Lesson(id: 's2', title: 'WHERE', content: 'WHERE filtra registros según condición.', code: 'SELECT * FROM estudiantes WHERE nivel = 1;', challenge: Challenge(question: 'WHERE permite...', options: ['Filtrar resultados', 'Crear ramas', 'Dibujar UI', 'Subir archivos'], correctIndex: 0)),
    Lesson(id: 's3', title: 'INSERT', content: 'INSERT agrega nuevos registros.', code: 'INSERT INTO estudiantes(nombre) VALUES ("Ana");', challenge: Challenge(question: 'INSERT sirve para...', options: ['Agregar datos', 'Eliminar tabla', 'Bloquear usuario', 'Cambiar SO'], correctIndex: 0)),
  ]),
];
