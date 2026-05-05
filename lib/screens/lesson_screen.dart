import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/challenge_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.course, required this.lesson});
  final Course course;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final i = course.lessons.indexOf(lesson) + 1;
    final p = i / course.lessons.length;
    return Scaffold(appBar: AppBar(title: Text(course.title), actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.help_outline))]), body: ListView(padding: const EdgeInsets.all(20), children: [
      Text(lesson.title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
      Text('Lección $i de ${course.lessons.length}', style: const TextStyle(color: Colors.white70, fontSize: 20)),
      const SizedBox(height: 8),
      LinearProgressIndicator(value: p, minHeight: 8, color: const Color(0xFF8B5CF6), backgroundColor: const Color(0xFF334155)),
      const SizedBox(height: 12),
      Text(lesson.content, style: const TextStyle(fontSize: 20, color: Colors.white70, height: 1.45)),
      const SizedBox(height: 16),
      const Text('Ejemplo:', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF020617), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF334155))), child: Text(lesson.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 20, color: Color(0xFF22D3EE)))),
      const SizedBox(height: 18),
      Text('Tu turno\n${lesson.tip}', style: const TextStyle(fontSize: 20, height: 1.4)),
      const SizedBox(height: 18),
      PrimaryButton(label: 'Continuar al desafío', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeScreen(course: course, lesson: lesson)))),
    ]));
  }
}
