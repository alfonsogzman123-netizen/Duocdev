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
  late final TextEditingController questionController;
  late final TextEditingController explanationController;
  late final TextEditingController xpController;
  late final List<TextEditingController> optionControllers;
  late int correctIndex;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.exercise.question);
    explanationController = TextEditingController(text: widget.exercise.explanation);
    xpController = TextEditingController(text: '${widget.exercise.xpReward}');
    optionControllers =
        widget.exercise.options.map((option) => TextEditingController(text: option)).toList();
    correctIndex = widget.exercise.correctIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revisar ejercicio')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DuocCard(
            child: Column(
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Pregunta'),
                ),
                ...List.generate(
                  optionControllers.length,
                  (index) => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: optionControllers[index],
                          decoration: InputDecoration(labelText: 'Opción ${index + 1}'),
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: correctIndex,
                        onChanged: (value) => setState(() => correctIndex = value ?? 0),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: explanationController,
                  decoration: const InputDecoration(labelText: 'Explicación'),
                ),
                TextField(
                  controller: xpController,
                  decoration: const InputDecoration(labelText: 'XP'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Guardar cambios',
            onPressed: () {
              exerciseGenerationService.updateExercise(
                widget.exercise.copyWith(
                  question: questionController.text,
                  options: optionControllers.map((option) => option.text).toList(),
                  correctIndex: correctIndex,
                  explanation: explanationController.text,
                  xpReward: int.tryParse(xpController.text) ?? widget.exercise.xpReward,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
