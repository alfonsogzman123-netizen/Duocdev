import 'package:flutter/material.dart';

void main() {
  runApp(const DuocDevApp());
}

class DuocDevApp extends StatelessWidget {
  const DuocDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuocDev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> cursos = const [
    {
      'titulo': 'Lógica de Programación',
      'nivel': 'Nivel 1',
      'descripcion': 'Pseudocódigo, variables, condiciones y ciclos',
      'progreso': '100%',
    },
    {
      'titulo': 'Python Básico',
      'nivel': 'Nivel 2',
      'descripcion': 'Variables, condicionales, ciclos y funciones',
      'progreso': '65%',
    },
    {
      'titulo': 'Git y GitHub',
      'nivel': 'Nivel 3',
      'descripcion': 'Control de versiones y repositorios',
      'progreso': '20%',
    },
    {
      'titulo': 'Desarrollo Web',
      'nivel': 'Nivel 4',
      'descripcion': 'HTML, CSS y JavaScript',
      'progreso': '0%',
    },
    {
      'titulo': 'Java',
      'nivel': 'Nivel 5',
      'descripcion': 'Programación orientada a objetos',
      'progreso': '0%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hola, Estudiante 👋',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Bienvenido a DuocDev',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu progreso general',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nivel 2',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(value: 0.65),
                    SizedBox(height: 8),
                    Text('650 / 1000 XP'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Ruta de aprendizaje',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: cursos.length,
                  itemBuilder: (context, index) {
                    final curso = cursos[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(  
                                onTap: () {
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(
                                         builder: (context) => CursoScreen(
                                            titulo: curso['titulo']!,
      ),
    ),
  );
},                   

                        leading: CircleAvatar(
                          backgroundColor: Colors.cyanAccent,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        title: Text(
                          curso['titulo']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${curso['nivel']} • ${curso['descripcion']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          curso['progreso']!,
                          style: const TextStyle(color: Colors.cyanAccent),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CursoScreen extends StatelessWidget {
  final String titulo;

  const CursoScreen({super.key, required this.titulo});

  List<String> obtenerLecciones() {
    if (titulo == 'Lógica de Programación') {
      return [
        'Introducción a la lógica',
        'Variables y datos',
        'Condicionales',
        'Ciclos',
        'Desafío final de lógica',
      ];
    }

    if (titulo == 'Python Básico') {
      return [
        '¿Qué es Python?',
        'Variables en Python',
        'Condicionales if/else',
        'Ciclos while y for',
        'Funciones básicas',
      ];
    }

    if (titulo == 'Git y GitHub') {
      return [
        '¿Qué es Git?',
        'Crear repositorios',
        'Commits',
        'Push y pull',
        'Subir proyecto a GitHub',
      ];
    }

    if (titulo == 'Desarrollo Web') {
      return [
        'Introducción a HTML',
        'Estructura de una página',
        'CSS básico',
        'JavaScript inicial',
        'Mini proyecto web',
      ];
    }

    if (titulo == 'Java') {
      return [
        'Introducción a Java',
        'Variables y tipos de datos',
        'Condicionales',
        'Ciclos',
        'Programación orientada a objetos',
      ];
    }

    return [
      'Introducción',
      'Conceptos básicos',
      'Ejercicios',
      'Desafío final',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final lecciones = obtenerLecciones();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: const Color(0xFF111827),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Completa las lecciones para ganar XP y avanzar de nivel.',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 24),

            const Text(
              'Lecciones',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: lecciones.length,
                itemBuilder: (context, index) {
                  final completada = index == 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                              builder: (context) => LeccionScreen(
                                tituloCurso: titulo,
                                tituloLeccion: lecciones[index],
        ),
      ),
    );
  },
  leading: Icon(
                        completada
                            ? Icons.check_circle
                            : Icons.play_circle_fill,
                        color: completada
                            ? Colors.greenAccent
                            : Colors.cyanAccent,
                      ),
                      title: Text(
                        lecciones[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        completada ? 'Completada' : 'Pendiente',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeccionScreen extends StatelessWidget {
  final String tituloCurso;
  final String tituloLeccion;

  const LeccionScreen({
    super.key,
    required this.tituloCurso,
    required this.tituloLeccion,
  });

  String obtenerContenido() {
    if (tituloLeccion == '¿Qué es Python?') {
      return 'Python es un lenguaje de programación fácil de leer y muy usado para crear aplicaciones, automatizar tareas, analizar datos y aprender programación.';
    }

    if (tituloLeccion == 'Variables en Python') {
      return 'Una variable permite guardar información. Por ejemplo, puedes guardar un nombre, una edad o un resultado.';
    }

    if (tituloLeccion == 'Condicionales if/else') {
      return 'Los condicionales permiten que un programa tome decisiones. Si una condición se cumple, ocurre una acción; si no, ocurre otra.';
    }

    if (tituloLeccion == '¿Qué es Git?') {
      return 'Git es una herramienta de control de versiones. Sirve para guardar cambios del código y poder volver a versiones anteriores.';
    }

    if (tituloLeccion == 'Commits') {
      return 'Un commit es como una fotografía del estado actual del proyecto. Sirve para registrar avances importantes.';
    }

    return 'Esta lección introduce conceptos importantes para avanzar en la ruta de aprendizaje de DuocDev.';
  }

  String obtenerCodigoEjemplo() {
    if (tituloLeccion == '¿Qué es Python?') {
      return 'print("Hola DuocDev")';
    }

    if (tituloLeccion == 'Variables en Python') {
      return 'nombre = "Alfonso"\nedad = 18\nprint(nombre)';
    }

    if (tituloLeccion == 'Condicionales if/else') {
      return 'edad = 18\n\nif edad >= 18:\n    print("Mayor de edad")\nelse:\n    print("Menor de edad")';
    }

    if (tituloLeccion == '¿Qué es Git?') {
      return 'git init\ngit status';
    }

    if (tituloLeccion == 'Commits') {
      return 'git add .\ngit commit -m "Agrega nueva función"';
    }

    return '// Próximamente agregaremos un ejemplo para esta lección';
  }

  @override
  Widget build(BuildContext context) {
    final contenido = obtenerContenido();
    final codigo = obtenerCodigoEjemplo();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(tituloCurso),
        backgroundColor: const Color(0xFF111827),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tituloLeccion,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              contenido,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Ejemplo de código',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Text(
                codigo,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  color: Colors.greenAccent,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Continuar al desafío',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}