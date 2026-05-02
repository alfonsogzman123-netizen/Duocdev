import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Center(child: CircleAvatar(radius: 46, backgroundColor: Color(0xFF1E293B), child: Icon(Icons.person, size: 48, color: Color(0xFF22D3EE)))),
      const SizedBox(height: 10),
      const Center(child: Text('Estudiante DuocDev', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
      const Center(child: Text('Ingeniería Informática', style: TextStyle(color: Colors.white70, fontSize: 18))),
      const SizedBox(height: 14),
      DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), Text('XP total ${progressService.xp}'), Text('Lecciones completadas ${progressService.completedCount}/${progressService.totalLessons}'), const SizedBox(height: 8), LinearProgressIndicator(value: progressService.overallProgress, minHeight: 8)])),
      const SizedBox(height: 12),
      const Text('Insignias', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      const Wrap(spacing: 8, runSpacing: 8, children: [Chip(label: Text('Primera lección')), Chip(label: Text('Racha 7 días')), Chip(label: Text('Python inicial')), Chip(label: Text('Git básico'))]),
    ]));
  }
}
