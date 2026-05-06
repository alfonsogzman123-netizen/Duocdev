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
    final firstPending = course.lessons
        .where(
          (lesson) => !progressService.isLessonCompleted(course.id, lesson.id),
        )
        .firstOrNull;
    final nextLesson =
        firstPending ?? (course.lessons.isEmpty ? null : course.lessons.first);
    final color = _color(course.id);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: _courseIcon(course.id),
            colors: [
              color.withValues(alpha: 0.85),
              const Color(0xFF1E1B4B),
              const Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: course.level,
                  color: const Color(0xFFFFFFFF),
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 16),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroChip(
                      '${course.lessons.length} lecciones',
                      Icons.menu_book_rounded,
                    ),
                    _HeroChip(
                      '${course.lessons.length * 45} XP disponibles',
                      Icons.bolt_rounded,
                    ),
                    _HeroChip(_difficulty(course.id), Icons.speed_rounded),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (nextLesson != null)
            PrimaryButton(
              label: 'Continuar curso',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LessonScreen(course: course, lesson: nextLesson),
                ),
              ),
            ),
          const SizedBox(height: 20),
          _PracticeCourseCard(course: course, practiceCount: practice.length),
          const SizedBox(height: 20),
          const SectionTitle('Lecciones'),
          const SizedBox(height: 12),
          ...course.lessons.asMap().entries.map((entry) {
            final lesson = entry.value;
            final done = progressService.isLessonCompleted(
              course.id,
              lesson.id,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LessonTile(
                index: entry.key + 1,
                lesson: lesson,
                done: done,
                color: color,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LessonScreen(course: course, lesson: lesson),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
          SectionTitle(
            'Ejercicios del profesor',
            trailing: StatusBadge(
              label: '${practice.length}',
              color: const Color(0xFF22D3EE),
              icon: Icons.auto_awesome,
            ),
          ),
          const SizedBox(height: 10),
          if (practice.isEmpty)
            EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'Sin ejercicios publicados',
              message:
                  'Cuando tu profesor publique ejercicios, aparecerán aquí con XP y dificultad.',
              action: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SmartPracticeScreen(courseId: course.id),
                  ),
                ),
                icon: const Icon(Icons.psychology_alt_rounded),
                label: const Text('Ver práctica inteligente'),
              ),
            )
          else
            ...practice
                .take(3)
                .map(
                  (exercise) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  exercise.sourceReference ??
                                      'Material docente',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          StatusBadge(
                            label: '+${exercise.xpReward} XP',
                            color: const Color(0xFFF59E0B),
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

class _PracticeCourseCard extends StatelessWidget {
  const _PracticeCourseCard({
    required this.course,
    required this.practiceCount,
  });

  final Course course;
  final int practiceCount;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            practiceCount == 0
                ? 'Cuando el profesor publique ejercicios, esta sección mostrará práctica personalizada.'
                : '$practiceCount ejercicios creados desde material académico y listos para practicar.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: practiceCount == 0
                ? 'Explorar práctica demo'
                : 'Practicar ahora',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SmartPracticeScreen(courseId: course.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.index,
    required this.lesson,
    required this.done,
    required this.color,
    required this.onTap,
  });

  final int index;
  final Lesson lesson;
  final bool done;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 20,
      padding: const EdgeInsets.all(15),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF14532D)
                  : color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: done
                    ? const Color(0xFF22C55E)
                    : color.withValues(alpha: 0.7),
              ),
            ),
            child: Icon(
              done ? Icons.check_rounded : Icons.play_arrow_rounded,
              color: done ? const Color(0xFF22C55E) : color,
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Lección $index • ${done ? 'Completada' : 'Pendiente'}',
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
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip(this.label, this.icon);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

double _demoProgress(String id) {
  return const {
        'logica': 1.0,
        'python': 0.75,
        'git': 0.6,
        'web': 0.35,
        'sql': 0.2,
      }[id] ??
      0.0;
}

String _difficulty(String id) {
  return const {
        'logica': 'Inicial',
        'python': 'Básico',
        'git': 'Básico',
        'web': 'Intermedio',
        'sql': 'Intermedio',
        'java': 'Intermedio',
        'cpp': 'Avanzado',
      }[id] ??
      'Básico';
}

IconData _courseIcon(String id) {
  return switch (id) {
    'logica' => Icons.schema_rounded,
    'python' => Icons.code_rounded,
    'git' => Icons.account_tree_rounded,
    'web' => Icons.language_rounded,
    'java' => Icons.coffee_rounded,
    'sql' => Icons.storage_rounded,
    _ => Icons.lock_rounded,
  };
}

Color _color(String id) {
  return const {
        'logica': Color(0xFF22C55E),
        'python': Color(0xFF8B5CF6),
        'git': Color(0xFFFB923C),
        'web': Color(0xFF38BDF8),
        'java': Color(0xFFF87171),
        'sql': Color(0xFF22D3EE),
      }[id] ??
      const Color(0xFF94A3B8);
}
