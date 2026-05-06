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
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Ruta de aprendizaje',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Domina los fundamentos antes de avanzar.',
            style: TextStyle(color: Colors.white70, fontSize: 17),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: const [
              _RouteFilter(label: 'Todos', selected: true),
              _RouteFilter(label: 'Básico'),
              _RouteFilter(label: 'Intermedio'),
              _RouteFilter(label: 'Avanzado'),
            ],
          ),
          const SizedBox(height: 16),
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _CourseRouteCard(
                index: index,
                course: course,
                locked: locked,
                progress: progress,
                hasPractice: hasPractice,
                onTap: locked
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseScreen(course: course),
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CourseRouteCard extends StatelessWidget {
  const _CourseRouteCard({
    required this.index,
    required this.course,
    required this.locked,
    required this.progress,
    required this.hasPractice,
    required this.onTap,
  });

  final int index;
  final Course course;
  final bool locked;
  final double progress;
  final bool hasPractice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            alignment: Alignment.center,
            child: Icon(
              _courseIcon(course.id),
              color: _color(course.id),
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${index + 1}. ${course.title}',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          height: 1.12,
                        ),
                      ),
                    ),
                    _StatusPill(
                      label: _statusLabel(locked: locked, progress: progress),
                      locked: locked,
                      progress: progress,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  course.description,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          color: _color(course.id),
                          backgroundColor: const Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Meta(
                      label: '${course.lessons.length} lecciones',
                      icon: Icons.menu_book_rounded,
                    ),
                    _Meta(
                      label: '${course.lessons.length * 45} XP estimado',
                      icon: Icons.bolt_rounded,
                    ),
                    if (hasPractice)
                      const _Meta(
                        label: 'Práctica docente',
                        icon: Icons.auto_awesome,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteFilter extends StatelessWidget {
  const _RouteFilter({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: selected
          ? const Color(0xFF8B5CF6)
          : const Color(0xFF1E293B),
      side: BorderSide(
        color: selected ? const Color(0xFF8B5CF6) : const Color(0xFF334155),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.locked,
    required this.progress,
  });

  final String label;
  final bool locked;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final color = locked
        ? const Color(0xFF94A3B8)
        : progress >= 1
        ? const Color(0xFF22C55E)
        : progress > 0
        ? const Color(0xFF8B5CF6)
        : const Color(0xFF22D3EE);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.75)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}

double _demoProgress(String id) {
  return const {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}[id] ??
      0.0;
}

String _statusLabel({required bool locked, required double progress}) {
  if (locked) return 'Próximamente';
  if (progress >= 1) return 'Completado';
  if (progress > 0) return 'En progreso';
  return 'Disponible';
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
