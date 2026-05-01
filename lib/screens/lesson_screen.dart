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
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(lesson.content, style: const TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 16),
          DuocCard(child: Text(lesson.code, style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent))),
          const Spacer(),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChallengeScreen(course: course, lesson: lesson))), child: const Text('Ir al desafío')))
        ]),
      ),
    );
  }
}
