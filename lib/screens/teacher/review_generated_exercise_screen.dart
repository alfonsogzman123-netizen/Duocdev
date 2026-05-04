import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ReviewGeneratedExerciseScreen extends StatefulWidget {
  const ReviewGeneratedExerciseScreen({super.key, required this.exercise});
  final GeneratedExercise exercise;

  @override
  State<ReviewGeneratedExerciseScreen> createState() => _ReviewGeneratedExerciseScreenState();
}

class _ReviewGeneratedExerciseScreenState extends State<ReviewGeneratedExerciseScreen> {
  late TextEditingController q; late TextEditingController ex; late TextEditingController xp; late List<TextEditingController> opts; int correct = 0;
  @override
  void initState() { super.initState(); q = TextEditingController(text: widget.exercise.question); ex = TextEditingController(text: widget.exercise.explanation); xp = TextEditingController(text: '${widget.exercise.xpReward}'); opts = widget.exercise.options.map((e) => TextEditingController(text: e)).toList(); correct = widget.exercise.correctIndex; }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Revisar ejercicio')), body: ListView(padding: const EdgeInsets.all(20), children: [DuocCard(child: Column(children: [TextField(controller: q, decoration: const InputDecoration(labelText: 'Pregunta')), ...List.generate(opts.length, (i) => Row(children: [Expanded(child: TextField(controller: opts[i], decoration: InputDecoration(labelText: 'Opción ${i + 1}'))), Radio<int>(value: i, groupValue: correct, onChanged: (v) => setState(() => correct = v ?? 0))])), TextField(controller: ex, decoration: const InputDecoration(labelText: 'Explicación')), TextField(controller: xp, decoration: const InputDecoration(labelText: 'XP'))])), const SizedBox(height: 10), PrimaryButton(label: 'Guardar cambios', onPressed: () { exerciseGenerationService.updateExercise(widget.exercise.copyWith(question: q.text, options: opts.map((e) => e.text).toList(), correctIndex: correct, explanation: ex.text, xpReward: int.tryParse(xp.text) ?? widget.exercise.xpReward)); Navigator.pop(context); })]));
}
