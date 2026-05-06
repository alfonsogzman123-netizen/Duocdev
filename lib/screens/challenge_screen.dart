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
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.quiz_rounded,
            colors: const [
              Color(0xFF7C2D12),
              Color(0xFF4C1D95),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: widget.lesson.title,
                  color: const Color(0xFFFFFFFF),
                  icon: Icons.menu_book_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Resuelve el desafío',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: answered ? 1 : (selected == null ? 0.35 : 0.7),
                    minHeight: 10,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Elige una alternativa y revisa el feedback inmediato.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DuocCard(
            radius: 24,
            child: Text(
              challenge.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
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
                letter: String.fromCharCode(65 + index),
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
            _FeedbackCard(
              correct: correct,
              lesson: widget.lesson,
              onRetry: correct
                  ? null
                  : () => setState(() {
                      selected = null;
                      answered = false;
                    }),
            ),
          ],
          const SizedBox(height: 20),
          PrimaryButton(
            label: answered ? 'Continuar' : 'Comprobar respuesta',
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
              style: const TextStyle(fontSize: 18, height: 1.25),
            ),
          ),
          const SizedBox(width: 8),
          Icon(_icon(), color: color),
        ],
      ),
    );
  }

  IconData _icon() {
    if (answered && correctAnswer) return Icons.check_circle_rounded;
    if (answered && selected) return Icons.lightbulb_rounded;
    return selected
        ? Icons.radio_button_checked_rounded
        : Icons.radio_button_unchecked_rounded;
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.correct,
    required this.lesson,
    required this.onRetry,
  });

  final bool correct;
  final Lesson lesson;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final color = correct ? const Color(0xFF22C55E) : const Color(0xFFFB923C);
    return HeroPanel(
      colors: correct
          ? const [Color(0xFF14532D), Color(0xFF0F172A)]
          : const [Color(0xFF7C2D12), Color(0xFF0F172A)],
      padding: const EdgeInsets.all(18),
      icon: correct ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(
            label: correct
                ? 'Correcto • +30 XP'
                : 'Pista • +10 XP por practicar',
            color: color,
            icon: correct
                ? Icons.check_circle_rounded
                : Icons.lightbulb_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            correct
                ? '¡Muy bien aplicado!'
                : 'Buen intento. Puedes intentarlo otra vez.',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            correct
                ? 'La alternativa correcta aplica el concepto en contexto, no solo lo memoriza.'
                : 'Vuelve al ejemplo de "${lesson.title}" y busca la opción que puedas explicar en código.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Intentar de nuevo'),
            ),
          ],
        ],
      ),
    );
  }
}
