import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Perfil', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
          const SizedBox(height: 16),
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 16),
          DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Nivel: ${progressService.level}'), Text('XP: ${progressService.xp}'), Text('Lecciones completadas: ${progressService.completedCount}/${progressService.totalLessons}'), const SizedBox(height: 8), LinearProgressIndicator(value: progressService.overallProgress)])),
        ],
      ),
    );
  }
}
