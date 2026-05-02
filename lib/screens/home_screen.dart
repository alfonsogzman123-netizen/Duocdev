import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onGoToRoute});
  final VoidCallback onGoToRoute;

  @override
  Widget build(BuildContext context) {
    final progress = progressService.overallProgress;
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(22), children: [
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.menu, size: 30), Icon(Icons.notifications_none, size: 30)]),
        const SizedBox(height: 18),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('¡Hola, Estudiante!', style: TextStyle(color: Colors.white70, fontSize: 20)),
            SizedBox(height: 4),
            Text('Bienvenido a', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800)),
            Text('DuocDev', style: TextStyle(fontSize: 38, color: Color(0xFF22D3EE), fontWeight: FontWeight.w800)),
            Text('Aprende. Practica. Progresa.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 18)),
          ])),
          const CircleAvatar(radius: 44, backgroundColor: Color(0xFF1E293B), child: Icon(Icons.laptop_mac, size: 44, color: Color(0xFF8B5CF6))),
        ]),
        const SizedBox(height: 18),
        DuocCard(child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tu progreso general', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
            const Text('Programador en formación', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 17)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: BorderRadius.circular(50), color: const Color(0xFF22D3EE), backgroundColor: const Color(0xFF334155)),
            const SizedBox(height: 8),
            Text('${progressService.xp} / 1000 XP', style: const TextStyle(color: Colors.white70, fontSize: 18)),
          ])),
          Stack(alignment: Alignment.center, children: [
            SizedBox(width: 82, height: 82, child: CircularProgressIndicator(value: progress, strokeWidth: 7, color: const Color(0xFF60A5FA), backgroundColor: const Color(0xFF334155))),
            Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          ]),
        ])),
        const SizedBox(height: 18),
        const SectionTitle('Racha diaria 🔥', trailing: Text('7 días', style: TextStyle(color: Color(0xFFFB923C), fontSize: 22, fontWeight: FontWeight.w700))),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10, children: const [
          _Stat(icon: Icons.menu_book_rounded, title: 'Lecciones', value: '32', color: Color(0xFF8B5CF6)),
          _Stat(icon: Icons.emoji_events, title: 'Retos', value: '14', color: Color(0xFFF59E0B)),
          _Stat(icon: Icons.code, title: 'Proyectos', value: '4', color: Color(0xFF38BDF8)),
          _Stat(icon: Icons.bar_chart, title: 'Ranking', value: '#12', color: Color(0xFFF59E0B)),
        ]),
        const SizedBox(height: 18),
        const Text('Continúa aprendiendo', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        DuocCard(onTap: onGoToRoute, child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text('🐍', style: TextStyle(fontSize: 38)), SizedBox(width: 10), Expanded(child: Text('Python Básico\nFunciones y módulos', style: TextStyle(fontSize: 20, height: 1.3))) ]),
          SizedBox(height: 12),
          LinearProgressIndicator(value: 0.75, minHeight: 8, color: Color(0xFF8B5CF6), backgroundColor: Color(0xFF334155)),
          SizedBox(height: 8),
          Align(alignment: Alignment.centerRight, child: Text('75%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
        ])),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.title, required this.value, required this.color});
  final IconData icon; final String title; final String value; final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(width: 160, child: DuocCard(child: Column(children: [Icon(icon, color: color, size: 32), const SizedBox(height: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)), Text(title, style: const TextStyle(color: Colors.white70))])));
}
