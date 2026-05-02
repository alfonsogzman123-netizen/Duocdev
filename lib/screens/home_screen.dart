import 'dart:math' as math;

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
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.menu, size: 30), Icon(Icons.notifications_none, size: 30)],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡Hola, Estudiante!', style: TextStyle(color: Colors.white70, fontSize: 20)),
                    SizedBox(height: 4),
                    Text('Bienvenido a', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                    Text('DuocDev', style: TextStyle(fontSize: 38, color: Color(0xFF22D3EE), fontWeight: FontWeight.w800)),
                    Text('Aprende. Practica. Progresa.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 18)),
                  ],
                ),
              ),
              const _HeroIllustration(),
            ],
          ),
          const SizedBox(height: 20),
          _PremiumProgressCard(progress: progress),
          const SizedBox(height: 20),
          const SectionTitle(
            'Racha diaria 🔥',
            trailing: Text('7 días', style: TextStyle(color: Color(0xFFFB923C), fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: const [
            _Stat(icon: Icons.menu_book_rounded, title: 'Lecciones', value: '32', color: Color(0xFF8B5CF6)),
            _Stat(icon: Icons.emoji_events, title: 'Retos', value: '14', color: Color(0xFFF59E0B)),
            _Stat(icon: Icons.code, title: 'Proyectos', value: '4', color: Color(0xFF38BDF8)),
            _Stat(icon: Icons.bar_chart, title: 'Ranking', value: '#12', color: Color(0xFFF59E0B)),
          ]),
          const SizedBox(height: 24),
          const Text('Continúa aprendiendo', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          DuocCard(
            onTap: onGoToRoute,
            radius: 24,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('🐍', style: TextStyle(fontSize: 42)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Python Básico\nFunciones y módulos', style: TextStyle(fontSize: 22, height: 1.25, fontWeight: FontWeight.w600)),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
                  ],
                ),
                SizedBox(height: 14),
                LinearProgressIndicator(value: 0.75, minHeight: 9, color: Color(0xFF8B5CF6), backgroundColor: Color(0xFF334155)),
                SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: Text('75%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 118,
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF8B5CF6)]),
                boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.35), blurRadius: 18)],
              ),
            ),
          ),
          Positioned(
            left: 2,
            top: 35,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF334155))),
              child: const Icon(Icons.code_rounded, color: Color(0xFF22D3EE), size: 28),
            ),
          ),
          const Positioned(right: 16, top: 26, child: Icon(Icons.school_rounded, size: 44, color: Colors.white)),
        ],
      ),
    );
  }
}

class _PremiumProgressCard extends StatelessWidget {
  const _PremiumProgressCard({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF111827), Color(0xFF172554)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 26, offset: const Offset(0, 12))],
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tu progreso general', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Nivel ${progressService.level}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
            const Text('Programador en formación', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 17)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: BorderRadius.circular(50), color: const Color(0xFF22D3EE), backgroundColor: const Color(0xFF334155)),
            const SizedBox(height: 8),
            Text('${progressService.xp} / 1000 XP', style: const TextStyle(color: Colors.white70, fontSize: 18)),
          ]),
        ),
        SizedBox(
          width: 92,
          height: 92,
          child: Stack(alignment: Alignment.center, children: [
            Transform.rotate(
              angle: -math.pi / 2,
              child: SizedBox(
                width: 92,
                height: 92,
                child: CircularProgressIndicator(value: progress, strokeWidth: 8, color: const Color(0xFF60A5FA), backgroundColor: const Color(0xFF334155)),
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF111827)),
              alignment: Alignment.center,
              child: Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.title, required this.value, required this.color});
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: DuocCard(
        radius: 20,
        child: Column(children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ]),
      ),
    );
  }
}
