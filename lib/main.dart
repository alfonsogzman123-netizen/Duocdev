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