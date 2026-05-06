import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/lesson_screen.dart';
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
    final hasNextLesson =
        currentIndex >= 0 && currentIndex < widget.course.lessons.length - 1;
    final nextLesson = hasNextLesson
        ? widget.course.lessons[currentIndex + 1]
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ok ? Icons.emoji_events : Icons.refresh,
                size: 84,
                color: ok ? const Color(0xFF22C55E) : const Color(0xFFFB923C),
              ),
              const SizedBox(height: 12),
              Text(
                ok ? '¡Correcto!' : 'Sigue practicando',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '+$earnedXp XP',
                style: const TextStyle(fontSize: 24, color: Color(0xFF22D3EE)),
              ),
              const SizedBox(height: 14),
              DuocCard(
                radius: 22,
                child: Column(
                  children: [
                    Text(
                      'Nivel ${progressService.level} • XP ${progressService.xp}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ok
                          ? 'Insignia demo desbloqueada: Primer desafío'
                          : 'Revisa la explicación y vuelve a intentarlo cuando quieras.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: hasNextLesson
                    ? 'Continuar aprendizaje'
                    : 'Volver al inicio',
                onPressed: () {
                  if (nextLesson == null) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        course: widget.course,
                        lesson: nextLesson,
                      ),
                    ),
                  );
                },
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
        ),
      ),
    );
  }
}
