import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/generated_exercise_challenge_screen.dart';
import 'package:duocdev/screens/lesson_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    final published = exerciseGenerationService.publishedForCourse(course.id);
    return Scaffold(appBar: AppBar(title: Text(course.title)), body: ListView(padding: const EdgeInsets.all(20), children: [
      DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(course.description, style: const TextStyle(color: Colors.white70, fontSize: 16)), const SizedBox(height: 8), Text('${course.lessons.length} lecciones', style: const TextStyle(fontSize: 16))])),
      const SizedBox(height: 12),
      ...course.lessons.map((l) { final done = progressService.isCompleted('${course.id}:${l.id}'); return Padding(padding: const EdgeInsets.only(bottom: 10), child: DuocCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(course: course, lesson: l))), child: Row(children: [Icon(done ? Icons.check_circle : Icons.play_circle_fill, color: done ? const Color(0xFF22C55E) : const Color(0xFF22D3EE)), const SizedBox(width: 10), Expanded(child: Text(l.title, style: const TextStyle(fontSize: 18))), Text(done ? 'Completada' : 'Pendiente')]))); }),
      const SizedBox(height: 16),
      const Text('Ejercicios del profesor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      if (published.isEmpty)
        const DuocCard(child: Text('Aún no hay ejercicios generados para este curso.'))
      else
        ...published.map((e) => Padding(padding: const EdgeInsets.only(bottom: 8), child: DuocCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratedExerciseChallengeScreen(exercise: e))), child: Text(e.question)))),
    ]));
  }
}
