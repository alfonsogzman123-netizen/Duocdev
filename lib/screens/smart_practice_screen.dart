import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/screens/generated_exercise_challenge_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class SmartPracticeScreen extends StatefulWidget {
  const SmartPracticeScreen({super.key, this.courseId});

  final String? courseId;

  @override
  State<SmartPracticeScreen> createState() => _SmartPracticeScreenState();
}

class _SmartPracticeScreenState extends State<SmartPracticeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await exerciseGenerationService.getExercises();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final exercises = exerciseGenerationService.studentPracticeExercises(
      courseId: widget.courseId,
    );
    final title = widget.courseId == null
        ? 'Práctica inteligente'
        : 'Práctica de ${_courseName(widget.courseId!)}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ejercicios generados desde material académico revisado por profesor.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 14),
          DuocCard(
            radius: 24,
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF22D3EE),
                  size: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _loading
                        ? 'Buscando ejercicios publicados...'
                        : exercises.isEmpty
                        ? 'Aún no hay ejercicios para este curso.'
                        : '${exercises.length} ejercicios listos para practicar',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (exercises.isEmpty && !_loading)
            const DuocCard(
              child: Text(
                'Cuando el profesor publique ejercicios, aparecerán aquí junto con recomendaciones y XP.',
              ),
            )
          else
            ...exercises.asMap().entries.map((entry) {
              final exercise = entry.value;
              final completed = progressService.isGeneratedExerciseCompleted(
                exercise.id,
              );
              final status = completed
                  ? 'Completado'
                  : entry.key == 0
                  ? 'Recomendado'
                  : 'Pendiente';
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PracticeExerciseCard(
                  exercise: exercise,
                  status: status,
                  completed: completed,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GeneratedExerciseChallengeScreen(exercise: exercise),
                    ),
                  ).then((_) => setState(() {})),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _courseName(String id) => courses
      .firstWhere((course) => course.id == id, orElse: () => courses.first)
      .title;
}

class _PracticeExerciseCard extends StatelessWidget {
  const _PracticeExerciseCard({
    required this.exercise,
    required this.status,
    required this.completed,
    required this.onTap,
  });

  final GeneratedExercise exercise;
  final String status;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 22,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusChip(label: status, completed: completed),
              const Spacer(),
              Text(
                '+${exercise.xpReward} XP',
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.question,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                icon: Icons.menu_book_rounded,
                label: _courseName(exercise.courseId),
              ),
              _MetaChip(
                icon: Icons.speed_rounded,
                label: _difficultyLabel(exercise.difficulty),
              ),
              if (exercise.sourceReference != null)
                _MetaChip(
                  icon: Icons.article_outlined,
                  label: 'Material docente',
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _courseName(String id) => courses
      .firstWhere((course) => course.id == id, orElse: () => courses.first)
      .title;

  String _difficultyLabel(ExerciseDifficulty difficulty) {
    return switch (difficulty) {
      ExerciseDifficulty.basic => 'Básico',
      ExerciseDifficulty.intermediate => 'Intermedio',
      ExerciseDifficulty.advanced => 'Avanzado',
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.completed});

  final String label;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFF14532D) : const Color(0xFF312E81),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: completed ? const Color(0xFF22C55E) : const Color(0xFF8B5CF6),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
