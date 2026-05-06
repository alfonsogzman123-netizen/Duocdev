import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/lesson_screen.dart';
import 'package:duocdev/screens/smart_practice_screen.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.course,
    required this.lesson,
    required this.selected,
  });

  final Course course;
  final Lesson lesson;
  final int selected;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final bool ok;
  late final int earnedXp;

  @override
  void initState() {
    super.initState();
    ok = widget.selected == widget.lesson.challenge.correctIndex;
    earnedXp = ok ? 30 : 10;
    progressService.completeLesson(
      '${widget.course.id}:${widget.lesson.id}',
      ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.course.lessons.indexOf(widget.lesson);
    final nextLesson =
        currentIndex >= 0 && currentIndex < widget.course.lessons.length - 1
        ? widget.course.lessons[currentIndex + 1]
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 26),
        children: [
          HeroPanel(
            icon: ok ? Icons.emoji_events_rounded : Icons.trending_up_rounded,
            colors: ok
                ? const [
                    Color(0xFF166534),
                    Color(0xFF1E1B4B),
                    Color(0xFF0F172A),
                  ]
                : const [
                    Color(0xFF7C2D12),
                    Color(0xFF312E81),
                    Color(0xFF0F172A),
                  ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: ok ? 'Desafío completado' : 'Práctica registrada',
                  color: ok ? const Color(0xFF22C55E) : const Color(0xFFFB923C),
                  icon: ok ? Icons.check_circle_rounded : Icons.refresh_rounded,
                ),
                const SizedBox(height: 18),
                const Text(
                  '¡Buen trabajo!',
                  style: TextStyle(
                    fontSize: 38,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ok
                      ? 'Aplicaste el concepto y sumaste XP para tu ruta.'
                      : 'Practicar también cuenta. Repasa la explicación y vuelve con más contexto.',
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _RewardBubble(value: '+$earnedXp', label: 'XP ganado'),
                    _RewardBubble(
                      value: '${progressService.streakDays}',
                      label: 'días de racha',
                    ),
                    _RewardBubble(
                      value: '${progressService.level}',
                      label: 'nivel actual',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ok ? 'Insignia demo desbloqueada' : 'Progreso guardado',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ok
                      ? 'Primer desafío: completaste una actividad con feedback inmediato.'
                      : 'La práctica queda registrada y te acerca al próximo nivel.',
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progressService.levelProgress,
                    minHeight: 10,
                    color: const Color(0xFF22D3EE),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progressService.xpIntoLevel}/${ProgressService.xpPerLevel} XP hacia el próximo nivel',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: nextLesson == null
                ? 'Continuar aprendiendo'
                : 'Siguiente lección',
            onPressed: () {
              if (nextLesson == null) {
                Navigator.popUntil(context, (route) => route.isFirst);
                return;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LessonScreen(course: widget.course, lesson: nextLesson),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SmartPracticeScreen(courseId: widget.course.id),
              ),
            ),
            icon: const Icon(Icons.psychology_alt_rounded),
            label: const Text('Practicar más'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('Volver a cursos'),
          ),
        ],
      ),
    );
  }
}

class _RewardBubble extends StatelessWidget {
  const _RewardBubble({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
