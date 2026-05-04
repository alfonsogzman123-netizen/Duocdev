import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class GeneratedExerciseChallengeScreen extends StatefulWidget {
  const GeneratedExerciseChallengeScreen({super.key, required this.exercise});
  final GeneratedExercise exercise;

  @override
  State<GeneratedExerciseChallengeScreen> createState() => _GeneratedExerciseChallengeScreenState();
}

class _GeneratedExerciseChallengeScreenState extends State<GeneratedExerciseChallengeScreen> {
  int? selected;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Práctica generada')), body: ListView(padding: const EdgeInsets.all(20), children: [
    DuocCard(child: Text(widget.exercise.question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
    const SizedBox(height: 8),
    ...widget.exercise.options.asMap().entries.map((e) => DuocCard(onTap: () => setState(() => selected = e.key), child: Row(children: [Expanded(child: Text(e.value)), Icon(selected == e.key ? Icons.check_circle : Icons.circle_outlined)]))),
    const SizedBox(height: 10),
    PrimaryButton(label: 'Responder', onPressed: selected == null ? null : () { final ok = selected == widget.exercise.correctIndex; progressService.completeGeneratedExercise(widget.exercise.id, widget.exercise.xpReward); showDialog(context: context, builder: (_) => AlertDialog(title: Text(ok ? '¡Correcto!' : 'Sigue practicando'), content: Text(widget.exercise.explanation), actions: [TextButton(onPressed: ()=>Navigator.popUntil(context, (r)=>r.isFirst), child: const Text('OK'))])); }),
  ]));
}
