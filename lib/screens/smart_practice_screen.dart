import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/screens/generated_exercise_challenge_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

enum _PracticeFilter { recommended, python, git, published, pending }

class SmartPracticeScreen extends StatefulWidget {
  const SmartPracticeScreen({super.key, this.courseId});

  final String? courseId;

  @override
  State<SmartPracticeScreen> createState() => _SmartPracticeScreenState();
}

class _SmartPracticeScreenState extends State<SmartPracticeScreen> {
  bool _loading = true;
  _PracticeFilter _filter = _PracticeFilter.recommended;

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
    final title = widget.courseId == null
        ? 'Práctica inteligente'
        : 'Práctica de ${_courseName(widget.courseId!)}';
    final exercises = _filteredExercises();
    final totalAvailable = exerciseGenerationService
        .studentPracticeExercises(courseId: widget.courseId)
        .length;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.psychology_alt_rounded,
            colors: const [
              Color(0xFF164E63),
              Color(0xFF4C1D95),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'Práctica adaptativa',
                  color: Color(0xFF22D3EE),
                  icon: Icons.auto_awesome,
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 33,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ejercicios creados desde material académico y rutas de aprendizaje.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroChip(
                      '$totalAvailable listos',
                      Icons.fact_check_rounded,
                    ),
                    _HeroChip(
                      '${progressService.generatedExercisesCompleted.length} completados',
                      Icons.check_circle_rounded,
                    ),
                    _HeroChip('XP inteligente', Icons.bolt_rounded),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _PracticeFilter.values.map((filter) {
              return ChoiceChip(
                label: Text(_filterLabel(filter)),
                selected: _filter == filter,
                selectedColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Color(0xFF334155)),
                onSelected: (_) => setState(() => _filter = filter),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const DuocCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Text('Buscando ejercicios publicados...')),
                ],
              ),
            )
          else if (exercises.isEmpty)
            EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'Sin ejercicios en este filtro',
              message:
                  'Cambia el filtro o espera a que el profesor publique más práctica desde material académico.',
              action: OutlinedButton.icon(
                onPressed: () =>
                    setState(() => _filter = _PracticeFilter.recommended),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ver recomendados'),
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
                  : exercise.published
                  ? 'Publicado'
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

  List<GeneratedExercise> _filteredExercises() {
    final recommended = exerciseGenerationService.studentPracticeExercises(
      courseId: widget.courseId,
    );
    final all = exerciseGenerationService.all;

    return switch (_filter) {
      _PracticeFilter.recommended => recommended,
      _PracticeFilter.python =>
        recommended.where((exercise) => exercise.courseId == 'python').toList(),
      _PracticeFilter.git =>
        recommended.where((exercise) => exercise.courseId == 'git').toList(),
      _PracticeFilter.published =>
        recommended.where((exercise) => exercise.published).toList(),
      _PracticeFilter.pending =>
        all
            .where(
              (exercise) =>
                  !exercise.published &&
                  (widget.courseId == null ||
                      exercise.courseId == widget.courseId),
            )
            .toList(),
    };
  }

  String _filterLabel(_PracticeFilter filter) {
    return switch (filter) {
      _PracticeFilter.recommended => 'Recomendados',
      _PracticeFilter.python => 'Python',
      _PracticeFilter.git => 'Git',
      _PracticeFilter.published => 'Publicados',
      _PracticeFilter.pending => 'Pendientes',
    };
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
      radius: 24,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(
                label: status,
                color: completed
                    ? const Color(0xFF22C55E)
                    : status == 'Pendiente'
                    ? const Color(0xFFFB923C)
                    : const Color(0xFF8B5CF6),
                icon: completed
                    ? Icons.check_circle_rounded
                    : status == 'Pendiente'
                    ? Icons.pending_actions_rounded
                    : Icons.auto_awesome,
              ),
              const Spacer(),
              StatusBadge(
                label: '+${exercise.xpReward} XP',
                color: const Color(0xFFF59E0B),
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            exercise.question,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                label: _courseName(exercise.courseId),
                color: const Color(0xFF22D3EE),
                icon: Icons.menu_book_rounded,
              ),
              StatusBadge(
                label: _difficultyLabel(exercise.difficulty),
                color: const Color(0xFF94A3B8),
                icon: Icons.speed_rounded,
              ),
              if (exercise.sourceReference != null)
                const StatusBadge(
                  label: 'Material docente',
                  color: Color(0xFF22C55E),
                  icon: Icons.article_outlined,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Practicar'),
            ),
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
          Icon(icon, color: Colors.white, size: 15),
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
