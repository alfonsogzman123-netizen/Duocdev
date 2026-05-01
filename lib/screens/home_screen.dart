import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onGoToRoute;
  const HomeScreen({super.key, required this.onGoToRoute});

  @override
  Widget build(BuildContext context) {
    final c = courses[1];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('¡Hola, Estudiante!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
          const Text('Aprende. Practica. Progresa.', style: TextStyle(color: Color(0xFF8C96B3))),
          const SizedBox(height: 16),
          DuocCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tu progreso general', style: TextStyle(color: Color(0xFF95A2C6))),
              const SizedBox(height: 10),
              Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DuocProgressBar(value: progressService.overallProgress, color: const Color(0xFF39E58C)),
              const SizedBox(height: 8),
              Text('${progressService.xp} / 1000 XP', style: const TextStyle(color: Color(0xFFA6B2D4))),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('Racha diaria 🔥', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
          const SizedBox(height: 10),
          const Text('7 días', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          const Text('Continúa aprendiendo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          DuocCard(
            child: Row(children: [
              const Icon(Icons.code, size: 40, color: Color(0xFF52A7FF)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text(c.lessons[2].title, style: const TextStyle(color: Color(0xFF95A2C6))), const SizedBox(height: 8), const DuocProgressBar(value: 0.75, color: Color(0xFF8B5CF6))])),
              const SizedBox(width: 8),
              const Text('75%')
            ]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onGoToRoute, child: const Text('Ver todos los cursos')),
        ],
      ),
    );
  }
}
