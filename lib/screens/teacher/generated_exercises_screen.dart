import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/screens/teacher/review_generated_exercise_screen.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class GeneratedExercisesScreen extends StatefulWidget {
  const GeneratedExercisesScreen({super.key, this.preselectedMaterialId});
  final String? preselectedMaterialId;

  @override
  State<GeneratedExercisesScreen> createState() => _GeneratedExercisesScreenState();
}

class _GeneratedExercisesScreenState extends State<GeneratedExercisesScreen> {
  String? selectedMaterialId;
  int quantity = 3;
  ExerciseDifficulty difficulty = ExerciseDifficulty.basic;
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    final materials = materialService.getMaterials();
    if (widget.preselectedMaterialId != null) {
      selectedMaterialId = widget.preselectedMaterialId;
    } else if (materials.isNotEmpty) {
      selectedMaterialId = materials.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = materialService.getMaterials();
    final selectedMaterial = materials.where((m) => m.id == selectedMaterialId).firstOrNull;
    final exercises = exerciseGenerationService.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Generar ejercicios')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DuocCard(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMaterialId,
                  items: materials
                      .map((material) => DropdownMenuItem(
                            value: material.id,
                            child: Text(material.title),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedMaterialId = value),
                  decoration: const InputDecoration(labelText: 'Material'),
                ),
                DropdownButtonFormField<int>(
                  value: quantity,
                  items: const [3, 5, 10]
                      .map((item) => DropdownMenuItem(value: item, child: Text('$item')))
                      .toList(),
                  onChanged: (value) => setState(() => quantity = value ?? 3),
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
                DropdownButtonFormField<ExerciseDifficulty>(
                  value: difficulty,
                  items: ExerciseDifficulty.values
                      .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                      .toList(),
                  onChanged: (value) => setState(() => difficulty = value ?? difficulty),
                  decoration: const InputDecoration(labelText: 'Dificultad'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: isGenerating ? 'Generando...' : 'Generar ejercicios',
            onPressed: selectedMaterial == null || isGenerating
                ? null
                : () async {
                    setState(() => isGenerating = true);
                    await exerciseGenerationService.generateExercisesFromMaterial(
                      material: selectedMaterial,
                      count: quantity,
                      difficulty: difficulty,
                    );
                    setState(() => isGenerating = false);
                  },
          ),
          const SizedBox(height: 12),
          ...exercises.map((exercise) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DuocCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.question, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ...exercise.options.asMap().entries.map(
                            (option) => Text('${option.key + 1}. ${option.value}${option.key == exercise.correctIndex ? ' ✅' : ''}'),
                          ),
                      Text('Explicación: ${exercise.explanation}'),
                      Text(
                        'XP: ${exercise.xpReward} • ${exercise.approved ? 'Aprobado' : 'No aprobado'} • ${exercise.published ? 'Publicado' : 'No publicado'}',
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              exerciseGenerationService.approveExercise(exercise.id);
                              setState(() {});
                            },
                            child: const Text('Aprobar ejercicio'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewGeneratedExerciseScreen(exercise: exercise),
                              ),
                            ).then((_) => setState(() {})),
                            child: const Text('Editar'),
                          ),
                          TextButton(
                            onPressed: () {
                              exerciseGenerationService.publishExercise(exercise.id);
                              setState(() {});
                            },
                            child: const Text('Publicar en curso'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
