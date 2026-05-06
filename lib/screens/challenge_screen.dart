import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/result_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    super.key,
    required this.course,
    required this.lesson,
  });

  final Course course;
  final Lesson lesson;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int? selected;
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    final challenge = widget.lesson.challenge;
    final correct = selected == challenge.correctIndex;

    return Scaffold(
      appBar: AppBar(title: const Text('Desafío')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.lesson.title,
            style: const TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          DuocCard(
            radius: 24,
            child: Text(
              challenge.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            challenge.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerCard(
                text: challenge.options[index],
                selected: selected == index,
                correctAnswer: challenge.correctIndex == index,
                answered: answered,
                onTap: answered ? null : () => setState(() => selected = index),
              ),
            ),
          ),
          if (answered) ...[
            const SizedBox(height: 8),
            _FeedbackCard(correct: correct, lesson: widget.lesson),
          ],
          const SizedBox(height: 20),
          PrimaryButton(
            label: answered ? 'Continuar' : 'Revisar respuesta',
            onPressed: selected == null
                ? null
                : answered
                ? () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        course: widget.course,
                        lesson: widget.lesson,
                        selected: selected!,
                      ),
                    ),
                  )
                : () => setState(() => answered = true),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
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
        : const Color(0xFF334155);
    return DuocCard(
      radius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, height: 1.25),
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

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.correct, required this.lesson});

  final bool correct;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 22,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            correct ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
            color: correct ? const Color(0xFF22C55E) : const Color(0xFFFB923C),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct
                      ? '¡Correcto! +30 XP'
                      : 'Buen intento. Recibirás +10 XP por practicar.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  correct
                      ? 'La alternativa correcta se enfoca en aplicar el concepto, no solo memorizarlo.'
                      : 'Pista: vuelve al ejemplo de "${lesson.title}" y busca la opción que puedas aplicar en código.',
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
