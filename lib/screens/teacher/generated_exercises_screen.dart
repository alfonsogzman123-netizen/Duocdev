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
  String? materialId;
  int count = 3;
  ExerciseDifficulty diff = ExerciseDifficulty.basic;
  bool loading = false;

  @override
void initState() {
  super.initState();

  final materials = materialService.getMaterials();

  materialId = widget.preselectedMaterialId ??
      (materials.isNotEmpty ? materials.first.id : null);
}

  @override
  Widget build(BuildContext context) {
    final mats = materialService.getMaterials();
    final current = mats.where((m) => m.id == materialId).isNotEmpty ? mats.where((m) => m.id == materialId).first : null;
    final list = exerciseGenerationService.all;
    return Scaffold(appBar: AppBar(title: const Text('Generar ejercicios')), body: ListView(padding: const EdgeInsets.all(20), children: [
      DuocCard(child: Column(children: [
        DropdownButtonFormField<String>(value: materialId, items: mats.map((m) => DropdownMenuItem(value: m.id, child: Text(m.title))).toList(), onChanged: (v) => setState(() => materialId = v), decoration: const InputDecoration(labelText: 'Material')),
        DropdownButtonFormField<int>(value: count, items: const [3, 5, 10].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(), onChanged: (v) => setState(() => count = v ?? 3), decoration: const InputDecoration(labelText: 'Cantidad')),
        DropdownButtonFormField<ExerciseDifficulty>(value: diff, items: ExerciseDifficulty.values.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(), onChanged: (v) => setState(() => diff = v ?? diff), decoration: const InputDecoration(labelText: 'Dificultad')),
      ])),
      const SizedBox(height: 10),
      PrimaryButton(label: loading ? 'Generando...' : 'Generar ejercicios', onPressed: current == null || loading ? null : () async { setState(() => loading = true); await exerciseGenerationService.generateExercisesFromMaterial(material: current, count: count, difficulty: diff); setState(() => loading = false); }),
      const SizedBox(height: 12),
      ...list.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(e.question, style: const TextStyle(fontWeight: FontWeight.w700)),
          ...e.options.asMap().entries.map((o) => Text('${o.key + 1}. ${o.value}${o.key == e.correctIndex ? ' ✅' : ''}')),
          Text('Explicación: ${e.explanation}'),
          Text('XP: ${e.xpReward} • ${e.approved ? 'Aprobado' : 'No aprobado'} • ${e.published ? 'Publicado' : 'No publicado'}'),
          Row(children: [
            TextButton(onPressed: () { exerciseGenerationService.approveExercise(e.id); setState(() {}); }, child: const Text('Aprobar ejercicio')),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewGeneratedExerciseScreen(exercise: e))).then((_) => setState(() {})), child: const Text('Editar')),
            TextButton(onPressed: () { exerciseGenerationService.publishExercise(e.id); setState(() {}); }, child: const Text('Publicar en curso')),
          ])
        ])),
      )),
    ]));
  }
}
