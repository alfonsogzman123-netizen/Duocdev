import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/challenge_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final Course course;
  final Lesson lesson;
  const LessonScreen({super.key, required this.course, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Text(lesson.title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Lección 5 de 12', style: TextStyle(color: Color(0xFF9AA6C9))),
          const SizedBox(height: 12),
          const DuocProgressBar(value: 0.75, color: Color(0xFF8B5CF6)),
          const SizedBox(height: 20),
          Text(lesson.content, style: const TextStyle(fontSize: 18, color: Color(0xFFC4CEE8), height: 1.5)),
          const SizedBox(height: 16),
          const Text('Ejemplo:', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DuocCard(child: Text(lesson.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 28, color: Color(0xFF87D7FF)))),
          const SizedBox(height: 18),
          const Text('Tu turno', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Crea una función que reciba tu nombre y muestre un mensaje personalizado.', style: TextStyle(color: Color(0xFFC4CEE8), fontSize: 18)),
          const SizedBox(height: 10),
          const DuocCard(child: Text('def mi_funcion(nombre):\n    # Escribe tu código aquí\n    pass', style: TextStyle(fontFamily: 'monospace', fontSize: 26, color: Color(0xFF6AB5FF)))),
          const SizedBox(height: 24),
          SizedBox(height: 56, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeScreen(course: course, lesson: lesson))), child: const Text('Siguiente lección')))
        ]),
      ),
    );
  }
}
