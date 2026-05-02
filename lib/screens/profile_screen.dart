import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(20), children: [
        const Center(child: CircleAvatar(radius: 46, backgroundColor: Color(0xFF1E293B), child: Icon(Icons.person, size: 48, color: Color(0xFF22D3EE)))),
        const SizedBox(height: 10),
        const Center(child: Text('Estudiante DuocDev', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
        const Center(child: Text('Ingeniería Informática', style: TextStyle(color: Colors.white70, fontSize: 18))),
        const SizedBox(height: 14),
        DuocCard(
          radius: 24,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            Text('XP total ${progressService.xp}'),
            Text('Lecciones completadas ${progressService.completedCount}/${progressService.totalLessons}'),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progressService.overallProgress, minHeight: 8, color: const Color(0xFF22D3EE), backgroundColor: const Color(0xFF334155)),
          ]),
        ),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10, children: const [
          _MiniStat(title: 'Cursos iniciados', value: '6', icon: Icons.play_circle_outline, color: Color(0xFF22D3EE)),
          _MiniStat(title: 'Retos completados', value: '14', icon: Icons.bolt, color: Color(0xFFF59E0B)),
          _MiniStat(title: 'Racha', value: '7 días', icon: Icons.local_fire_department, color: Color(0xFFFB923C)),
          _MiniStat(title: 'Insignias', value: '4', icon: Icons.workspace_premium, color: Color(0xFF8B5CF6)),
        ]),
        const SizedBox(height: 14),
        const Text('Insignias', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Wrap(spacing: 8, runSpacing: 8, children: [Chip(label: Text('Primera lección')), Chip(label: Text('Racha 7 días')), Chip(label: Text('Python inicial')), Chip(label: Text('Git básico'))]),
      ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.title, required this.value, required this.icon, required this.color});
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: DuocCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ]),
      ),
    );
  }
}
