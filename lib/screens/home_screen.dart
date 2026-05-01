import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onGoToRoute;
  const HomeScreen({super.key, required this.onGoToRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Bienvenido a DuocDev', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
          const SizedBox(height: 16),
          DuocCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progressService.overallProgress),
              const SizedBox(height: 8),
              Text('XP: ${progressService.xp} • Lecciones: ${progressService.completedCount}/${progressService.totalLessons}'),
            ]),
          ),
          const Spacer(),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onGoToRoute, child: const Text('Continuar aprendiendo'))),
        ]),
      ),
    );
  }
}
