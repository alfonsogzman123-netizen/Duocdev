import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Course course;
  final Lesson lesson;
  final int selected;
  const ResultScreen({super.key, required this.course, required this.lesson, required this.selected});

  @override
  Widget build(BuildContext context) {
    final ok = selected == lesson.challenge.correctIndex;
    progressService.completeLesson('${course.id}:${lesson.id}', ok);
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(ok ? Icons.emoji_events : Icons.refresh, size: 72, color: ok ? Colors.greenAccent : Colors.orangeAccent),
            const SizedBox(height: 16),
            Text(ok ? '¡Correcto! +30 XP' : 'Respuesta incorrecta (+10 XP por intentarlo)', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Nivel ${progressService.level} • XP ${progressService.xp}'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Volver al inicio'))
          ]),
        ),
      ),
    );
  }
}
