import 'dart:math' as math;

import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/course_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.route_rounded,
            colors: const [
              Color(0xFF0E7490),
              Color(0xFF312E81),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                StatusBadge(
                  label: 'Ruta DuocDev',
                  color: Color(0xFF22D3EE),
                  icon: Icons.school_rounded,
                ),
                SizedBox(height: 14),
                Text(
                  'Domina programación paso a paso',
                  style: TextStyle(
                    fontSize: 31,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cursos cortos, práctica inteligente y progreso medible para avanzar con confianza.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _RouteSummary(),
          const SizedBox(height: 18),
          const SectionTitle('Roadmap de cursos'),
          const SizedBox(height: 12),
          ...courses.asMap().entries.map((entry) {
            final index = entry.key;
            final course = entry.value;
            final locked = course.status == CourseStatus.locked;
            final progress = math.max(
              progressService.courseProgress(course.id),
              _demoProgress(course.id),
            );
            final hasPractice = exerciseGenerationService.hasStudentPractice(
              courseId: course.id,
            );

            return _RoadmapCourseCard(
              index: index,
              total: courses.length,
              course: course,
              progress: progress,
              locked: locked,
              hasPractice: hasPractice,
              onTap: locked
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseScreen(course: course),
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        MetricTile(
          icon: Icons.menu_book_rounded,
          label: 'Cursos activos',
          value: '6',
          color: Color(0xFF22D3EE),
        ),
        MetricTile(
          icon: Icons.bolt_rounded,
          label: 'XP disponible',
          value: '1.890',
          color: Color(0xFF8B5CF6),
        ),
        MetricTile(
          icon: Icons.auto_awesome,
          label: 'Prácticas IA',
          value: '6',
          color: Color(0xFFFB923C),
        ),
      ],
    );
  }
}

class _RoadmapCourseCard extends StatelessWidget {
  const _RoadmapCourseCard({
    required this.index,
    required this.total,
    required this.course,
    required this.progress,
    required this.locked,
    required this.hasPractice,
    required this.onTap,
  });

  final int index;
  final int total;
  final Course course;
  final double progress;
  final bool locked;
  final bool hasPractice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _color(course.id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.18),
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: locked
                    ? const Icon(
                        Icons.lock_rounded,
                        size: 20,
                        color: Colors.white70,
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
            if (index < total - 1)
              Container(
                width: 2,
                height: 92,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: const Color(0xFF334155),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: index < total - 1 ? 12 : 0),
            child: DuocCard(
              radius: 24,
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: color.withValues(alpha: 0.65),
                          ),
                        ),
                        child: Icon(
                          _courseIcon(course.id),
                          color: color,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${course.level} • ${_difficulty(course.id)}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(
                        label: _statusLabel(locked: locked, progress: progress),
                        color: locked
                            ? const Color(0xFF94A3B8)
                            : progress >= 1
                            ? const Color(0xFF22C55E)
                            : progress > 0
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF22D3EE),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.description,
                    style: const TextStyle(color: Colors.white70, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      color: color,
                      backgroundColor: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusBadge(
                        label: '${course.lessons.length} lecciones',
                        color: const Color(0xFF94A3B8),
                        icon: Icons.menu_book_rounded,
                      ),
                      StatusBadge(
                        label: '${course.lessons.length * 45} XP',
                        color: const Color(0xFFF59E0B),
                        icon: Icons.bolt_rounded,
                      ),
                      if (hasPractice)
                        const StatusBadge(
                          label: 'Práctica inteligente',
                          color: Color(0xFF22D3EE),
                          icon: Icons.auto_awesome,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
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

String _statusLabel({required bool locked, required double progress}) {
  if (locked) return 'Próximamente';
  if (progress >= 1) return 'Completado';
  if (progress > 0) return 'En progreso';
  return 'Disponible';
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
