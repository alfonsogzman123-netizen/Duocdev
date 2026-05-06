import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class GeneratedExerciseChallengeScreen extends StatefulWidget {
  const GeneratedExerciseChallengeScreen({super.key, required this.exercise});

  final GeneratedExercise exercise;

  @override
  State<GeneratedExerciseChallengeScreen> createState() =>
      _GeneratedExerciseChallengeScreenState();
}

class _GeneratedExerciseChallengeScreenState
    extends State<GeneratedExerciseChallengeScreen> {
  int? selected;
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    final ok = selected == widget.exercise.correctIndex;
    return Scaffold(
      appBar: AppBar(title: const Text('Práctica generada')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Material académico',
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exercise.question,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_difficultyLabel(widget.exercise.difficulty)} • +${widget.exercise.xpReward} XP',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...widget.exercise.options.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GeneratedOptionCard(
                text: entry.value,
                selected: selected == entry.key,
                correctAnswer: widget.exercise.correctIndex == entry.key,
                answered: answered,
                onTap: answered
                    ? null
                    : () => setState(() => selected = entry.key),
              ),
            ),
          ),
          if (answered) ...[
            const SizedBox(height: 8),
            DuocCard(
              radius: 22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    ok ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
                    color: ok
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFFB923C),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ok
                              ? '¡Correcto! +${widget.exercise.xpReward} XP'
                              : 'Pista para mejorar',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.exercise.explanation,
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: answered ? 'Volver a práctica' : 'Revisar respuesta',
            onPressed: selected == null
                ? null
                : answered
                ? () => Navigator.pop(context)
                : () {
                    if (ok) {
                      progressService.completeGeneratedExercise(
                        widget.exercise.id,
                        widget.exercise.xpReward,
                      );
                    }
                    setState(() => answered = true);
                  },
          ),
        ],
      ),
    );
  }

  String _difficultyLabel(ExerciseDifficulty difficulty) {
    return switch (difficulty) {
      ExerciseDifficulty.basic => 'Básico',
      ExerciseDifficulty.intermediate => 'Intermedio',
      ExerciseDifficulty.advanced => 'Avanzado',
    };
  }
}

class _GeneratedOptionCard extends StatelessWidget {
  const _GeneratedOptionCard({
    required this.text,
    required this.selected,
    required this.correctAnswer,
    required this.answered,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool correctAnswer;
  final bool answered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = answered && correctAnswer
        ? const Color(0xFF22C55E)
        : answered && selected
        ? const Color(0xFFFB923C)
        : selected
        ? const Color(0xFF8B5CF6)
        : const Color(0xFF94A3B8);
    return DuocCard(
      radius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, height: 1.25),
            ),
          ),
          Icon(_icon(), color: color),
        ],
      ),
    );
  }

  IconData _icon() {
    if (answered && correctAnswer) return Icons.check_circle_rounded;
    if (answered && selected) return Icons.info_rounded;
    return selected
        ? Icons.radio_button_checked_rounded
        : Icons.radio_button_unchecked_rounded;
  }
}
