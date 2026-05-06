import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ok = selected == lesson.challenge.correctIndex;
    progressService.completeLesson('${course.id}:${lesson.id}', ok);
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
                ok ? '+30 XP' : '+10 XP',
                style: const TextStyle(fontSize: 24, color: Color(0xFF22D3EE)),
              ),
              const SizedBox(height: 14),
              DuocCard(
                radius: 22,
                child: Text(
                  'Nivel ${progressService.level} • XP ${progressService.xp}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Volver a la ruta',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
