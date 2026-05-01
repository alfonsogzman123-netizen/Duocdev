import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/lesson_screen.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  final Course course;
  const CourseScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: course.lessons.length,
        itemBuilder: (context, index) {
          final l = course.lessons[index];
          final key = '${course.id}:${l.id}';
          final done = progressService.isCompleted(key);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(course: course, lesson: l))),
              child: DuocCard(child: Row(children: [Icon(done ? Icons.check_circle : Icons.play_circle, color: done ? Colors.greenAccent : Colors.cyanAccent), const SizedBox(width: 12), Expanded(child: Text(l.title)), if (done) const Text('Completada')]))),
            ),
          );
        },
      ),
    );
  }
}
