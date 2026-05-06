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
                  label: 'Material docente',
                  color: Color(0xFF22D3EE),
                  icon: Icons.article_outlined,
                ),
                const SizedBox(height: 14),
                Text(
                  widget.exercise.question,
                  style: const TextStyle(
                    fontSize: 27,
                    height: 1.12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusBadge(
                      label: _difficultyLabel(widget.exercise.difficulty),
                      color: const Color(0xFF94A3B8),
                      icon: Icons.speed_rounded,
                    ),
                    StatusBadge(
                      label: '+${widget.exercise.xpReward} XP',
                      color: const Color(0xFFF59E0B),
                      icon: Icons.bolt_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...widget.exercise.options.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GeneratedOptionCard(
                letter: String.fromCharCode(65 + entry.key),
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
            HeroPanel(
              colors: ok
                  ? const [Color(0xFF14532D), Color(0xFF0F172A)]
                  : const [Color(0xFF7C2D12), Color(0xFF0F172A)],
              padding: const EdgeInsets.all(18),
              icon: ok ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(
                    label: ok ? 'Correcto' : 'Pista para mejorar',
                    color: ok
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFFB923C),
                    icon: ok
                        ? Icons.check_circle_rounded
                        : Icons.lightbulb_rounded,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ok ? '¡Excelente práctica!' : 'Buen intento',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.exercise.explanation,
                    style: const TextStyle(color: Colors.white70, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: answered ? 'Volver a práctica' : 'Comprobar respuesta',
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
    required this.letter,
    required this.text,
    required this.selected,
    required this.correctAnswer,
    required this.answered,
    required this.onTap,
  });

  final String letter;
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
        : const Color(0xFF334155);
    return DuocCard(
      radius: 22,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
