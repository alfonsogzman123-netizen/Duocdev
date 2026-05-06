import 'dart:math' as math;

import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/generated_exercise_challenge_screen.dart';
import 'package:duocdev/screens/lesson_screen.dart';
import 'package:duocdev/screens/smart_practice_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final practice = exerciseGenerationService.studentPracticeExercises(
      courseId: course.id,
    );
    final progress = math.max(
      progressService.courseProgress(course.id),
      _demoProgress(course.id),
    );
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.level,
                  style: const TextStyle(
                    color: Color(0xFF22D3EE),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: const Color(0xFF8B5CF6),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${course.lessons.length} lecciones • ${(progress * 100).round()}% completado',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (practice.isNotEmpty)
            DuocCard(
              radius: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Color(0xFF22D3EE)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Práctica inteligente del curso',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${practice.length} ejercicios publicados desde material académico.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Practicar ahora',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SmartPracticeScreen(courseId: course.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
          const SectionTitle('Microlecciones'),
          const SizedBox(height: 10),
          ...course.lessons.asMap().entries.map((entry) {
            final lesson = entry.value;
            final done = progressService.isCompleted(
              '${course.id}:${lesson.id}',
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DuocCard(
                radius: 20,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LessonScreen(course: course, lesson: lesson),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: done
                          ? const Color(0xFF14532D)
                          : const Color(0xFF0F172A),
                      child: Icon(
                        done ? Icons.check_rounded : Icons.play_arrow_rounded,
                        color: done
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF22D3EE),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Lección ${entry.key + 1} • ${done ? 'Completada' : 'Pendiente'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'Ejercicios del profesor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (practice.isEmpty)
            const DuocCard(
              child: Text('Aún no hay ejercicios generados para este curso.'),
            )
          else
            ...practice
                .take(3)
                .map(
                  (exercise) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DuocCard(
                      radius: 20,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GeneratedExerciseChallengeScreen(
                            exercise: exercise,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.question,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '+${exercise.xpReward} XP',
                            style: const TextStyle(
                              color: Color(0xFF22D3EE),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

double _demoProgress(String id) {
  return const {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}[id] ??
      0.0;
}
