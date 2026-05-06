import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/screens/teacher/review_generated_exercise_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

enum _ExerciseFilter { all, pending, approved, published }

class GeneratedExercisesScreen extends StatefulWidget {
  const GeneratedExercisesScreen({super.key, this.preselectedMaterialId});

  final String? preselectedMaterialId;

  @override
  State<GeneratedExercisesScreen> createState() =>
      _GeneratedExercisesScreenState();
}

class _GeneratedExercisesScreenState extends State<GeneratedExercisesScreen> {
  String? selectedMaterialId;
  int quantity = 3;
  ExerciseDifficulty difficulty = ExerciseDifficulty.basic;
  bool isGenerating = false;
  _ExerciseFilter filter = _ExerciseFilter.all;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await materialService.getMaterials();
    await exerciseGenerationService.getExercises();
    final materials = materialService.cachedMaterials;
    if (widget.preselectedMaterialId != null) {
      selectedMaterialId = widget.preselectedMaterialId;
    } else if (materials.isNotEmpty && selectedMaterialId == null) {
      selectedMaterialId = materials.first.id;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final materials = materialService.cachedMaterials;
    final selectedMaterial = materials
        .where((material) => material.id == selectedMaterialId)
        .firstOrNull;
    final exercises = _filtered(exerciseGenerationService.all);
    final all = exerciseGenerationService.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Banco de ejercicios')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.fact_check_rounded,
            colors: const [
              Color(0xFF312E81),
              Color(0xFF164E63),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'Banco docente',
                  color: Color(0xFF22D3EE),
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Banco de ejercicios',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Revisa, ajusta, aprueba y publica práctica generada desde material académico.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroChip('${all.length} generados', Icons.auto_awesome),
                    _HeroChip(
                      '${all.where((e) => e.approved).length} aprobados',
                      Icons.check_circle_outline,
                    ),
                    _HeroChip(
                      '${all.where((e) => e.published).length} publicados',
                      Icons.publish_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _GenerationCard(
            materials: materials,
            selectedMaterialId: selectedMaterialId,
            quantity: quantity,
            difficulty: difficulty,
            isGenerating: isGenerating,
            onMaterialChanged: (value) =>
                setState(() => selectedMaterialId = value),
            onQuantityChanged: (value) => setState(() => quantity = value ?? 3),
            onDifficultyChanged: (value) =>
                setState(() => difficulty = value ?? difficulty),
            onGenerate: selectedMaterial == null || isGenerating
                ? null
                : () async {
                    setState(() => isGenerating = true);
                    await exerciseGenerationService
                        .generateExercisesFromMaterial(
                          material: selectedMaterial,
                          count: quantity,
                          difficulty: difficulty,
                        );
                    if (!context.mounted) return;
                    if (exerciseGenerationService.lastInfoMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            exerciseGenerationService.lastInfoMessage!,
                          ),
                        ),
                      );
                    }
                    setState(() => isGenerating = false);
                  },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ExerciseFilter.values.map((item) {
              return ChoiceChip(
                label: Text(_filterLabel(item)),
                selected: filter == item,
                selectedColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFF1E293B),
                side: const BorderSide(color: Color(0xFF334155)),
                onSelected: (_) => setState(() => filter = item),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          if (exercises.isEmpty)
            const EmptyState(
              icon: Icons.fact_check_outlined,
              title: 'No hay ejercicios en este filtro',
              message:
                  'Genera nuevos ejercicios o cambia el filtro para revisar el banco docente.',
            )
          else
            ...exercises.map(
              (exercise) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ExerciseBankCard(
                  exercise: exercise,
                  onApprove: () async {
                    await exerciseGenerationService.approveExercise(
                      exercise.id,
                    );
                    if (mounted) setState(() {});
                  },
                  onPublish: () async {
                    await exerciseGenerationService.publishExercise(
                      exercise.id,
                    );
                    if (mounted) setState(() {});
                  },
                  onReview: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ReviewGeneratedExerciseScreen(exercise: exercise),
                    ),
                  ).then((_) => setState(() {})),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<GeneratedExercise> _filtered(List<GeneratedExercise> exercises) {
    return switch (filter) {
      _ExerciseFilter.all => exercises,
      _ExerciseFilter.pending =>
        exercises
            .where((exercise) => !exercise.approved && !exercise.published)
            .toList(),
      _ExerciseFilter.approved =>
        exercises
            .where((exercise) => exercise.approved && !exercise.published)
            .toList(),
      _ExerciseFilter.published =>
        exercises.where((exercise) => exercise.published).toList(),
    };
  }

  String _filterLabel(_ExerciseFilter value) {
    return switch (value) {
      _ExerciseFilter.all => 'Todos',
      _ExerciseFilter.pending => 'Pendientes',
      _ExerciseFilter.approved => 'Aprobados',
      _ExerciseFilter.published => 'Publicados',
    };
  }
}

class _GenerationCard extends StatelessWidget {
  const _GenerationCard({
    required this.materials,
    required this.selectedMaterialId,
    required this.quantity,
    required this.difficulty,
    required this.isGenerating,
    required this.onMaterialChanged,
    required this.onQuantityChanged,
    required this.onDifficultyChanged,
    required this.onGenerate,
  });

  final List<AcademicMaterial> materials;
  final String? selectedMaterialId;
  final int quantity;
  final ExerciseDifficulty difficulty;
  final bool isGenerating;
  final ValueChanged<String?> onMaterialChanged;
  final ValueChanged<int?> onQuantityChanged;
  final ValueChanged<ExerciseDifficulty?> onDifficultyChanged;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_fix_high_rounded, color: Color(0xFF22D3EE)),
              SizedBox(width: 8),
              Text(
                'Generar desde material',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (materials.isEmpty)
            const Text(
              'Primero sube o sincroniza material académico.',
              style: TextStyle(color: Colors.white70),
            )
          else ...[
            DropdownButtonFormField<String>(
              initialValue: selectedMaterialId ?? materials.first.id,
              items: materials
                  .map(
                    (material) => DropdownMenuItem<String>(
                      value: material.id,
                      child: Text(material.title),
                    ),
                  )
                  .toList(),
              onChanged: onMaterialChanged,
              decoration: const InputDecoration(labelText: 'Material'),
            ),
            DropdownButtonFormField<int>(
              initialValue: quantity,
              items: const [3, 5, 10]
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text('$item')),
                  )
                  .toList(),
              onChanged: onQuantityChanged,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            DropdownButtonFormField<ExerciseDifficulty>(
              initialValue: difficulty,
              items: ExerciseDifficulty.values
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(_difficultyLabel(item)),
                    ),
                  )
                  .toList(),
              onChanged: onDifficultyChanged,
              decoration: const InputDecoration(labelText: 'Dificultad'),
            ),
          ],
          const SizedBox(height: 14),
          PrimaryButton(
            label: isGenerating ? 'Generando...' : 'Generar ejercicios',
            onPressed: onGenerate,
          ),
        ],
      ),
    );
  }
}

class _ExerciseBankCard extends StatelessWidget {
  const _ExerciseBankCard({
    required this.exercise,
    required this.onApprove,
    required this.onPublish,
    required this.onReview,
  });

  final GeneratedExercise exercise;
  final VoidCallback onApprove;
  final VoidCallback onPublish;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(
                label: _stateLabel(exercise),
                color: exercise.published
                    ? const Color(0xFF22C55E)
                    : exercise.approved
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFFFB923C),
                icon: exercise.published
                    ? Icons.publish_rounded
                    : exercise.approved
                    ? Icons.check_circle_outline
                    : Icons.pending_actions_rounded,
              ),
              const Spacer(),
              StatusBadge(
                label: '+${exercise.xpReward} XP',
                color: const Color(0xFFF59E0B),
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.question,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
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
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Explicación: ${exercise.explanation}',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onReview,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Revisar'),
              ),
              OutlinedButton.icon(
                onPressed: exercise.approved ? null : onApprove,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Aprobar'),
              ),
              FilledButton.icon(
                onPressed: exercise.published ? null : onPublish,
                icon: const Icon(Icons.publish_rounded),
                label: const Text('Publicar'),
              ),
            ],
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

String _stateLabel(GeneratedExercise exercise) {
  if (exercise.published) return 'Publicado';
  if (exercise.approved) return 'Aprobado';
  return 'Pendiente';
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
