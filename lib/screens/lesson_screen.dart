import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/challenge_screen.dart';
import 'package:duocdev/screens/tutor_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final index = course.lessons.indexOf(lesson) + 1;
    final progress = course.lessons.isEmpty
        ? 0.0
        : index / course.lessons.length;
    final lessonContext =
        '${course.title} > ${lesson.title}\n${lesson.content}\nEjemplo:\n${lesson.code}';

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            lesson.title,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Lección $index de ${course.lessons.length}',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: const Color(0xFF8B5CF6),
              backgroundColor: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 18),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Qué aprenderás',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ..._learningGoals(lesson).map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF22C55E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explicación breve',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.content,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ejemplo de código',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Text(
              lesson.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                color: Color(0xFF22D3EE),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DuocCard(
            radius: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school_rounded, color: Color(0xFFFB923C)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lesson.tip,
                    style: const TextStyle(fontSize: 17, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Continuar al desafío',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChallengeScreen(course: course, lesson: lesson),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TutorScreen(
                  initialMode: TutorMode.lesson,
                  initialQuestion:
                      'Resume esta lección y dame un ejemplo corto.',
                  lessonContext: lessonContext,
                ),
              ),
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Preguntar al Tutor IA sobre esta lección'),
          ),
        ],
      ),
    );
  }
}

List<String> _learningGoals(Lesson lesson) {
  return [
    'Comprender el concepto de ${lesson.title.toLowerCase()} en contexto.',
    'Leer un ejemplo corto y reconocer sus partes importantes.',
    'Prepararte para responder un desafío con feedback inmediato.',
  ];
}
