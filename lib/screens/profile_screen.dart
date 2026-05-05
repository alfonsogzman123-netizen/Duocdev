import 'package:duocdev/screens/teacher/teacher_dashboard_screen.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final level = progressService.level;
    final xp = progressService.xp;
    final progress = (xp / 1000).clamp(0.0, 1.0);
    final badges = const ['Primera lección', 'Racha 7 días', 'Python inicial', 'Git básico'];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Perfil', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
              Icon(Icons.settings_outlined, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 16),
          const _ProfileHeader(),
          const SizedBox(height: 16),
          _LevelCard(level: level, progress: progress, xp: xp),
          const SizedBox(height: 14),
          const Text('Resumen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryCard(title: 'Cursos iniciados', value: '6', icon: Icons.menu_book_rounded, color: const Color(0xFF22D3EE)),
              _SummaryCard(title: 'Insignias', value: '${progressService.badges.length}', icon: Icons.workspace_premium, color: const Color(0xFF8B5CF6)),
              _SummaryCard(title: 'Días de racha', value: '${progressService.streakDays}', icon: Icons.local_fire_department, color: const Color(0xFFFB923C)),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Insignias recientes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          DuocCard(
            radius: 22,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badges
                  .map((badge) => Chip(
                        label: Text(badge),
                        avatar: const Icon(Icons.check_circle_outline, size: 18),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Entrar como profesor',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)]),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.person, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text('Estudiante DuocDev', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Ingeniería Informática', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Text('Duoc UC', style: TextStyle(color: Color(0xFF22D3EE), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.progress, required this.xp});

  final int level;
  final double progress;
  final int xp;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nivel $level', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const Text('Programador en formación', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: const Color(0xFF22D3EE),
                  backgroundColor: const Color(0xFF334155),
                ),
                const SizedBox(height: 8),
                Text('$xp / 1000 XP', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0xFF1E293B),
            child: Text('$level', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF8B5CF6))),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
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
