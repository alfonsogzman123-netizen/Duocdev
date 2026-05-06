import 'package:duocdev/screens/teacher/teacher_dashboard_screen.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final level = progressService.level;
    final progress = progressService.levelProgress;
    final badges = progressService.badgeCatalog;
    final earnedBadges = badges.where((badge) => badge.earned).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.workspace_premium_rounded,
            colors: const [
              Color(0xFF312E81),
              Color(0xFF164E63),
              Color(0xFF0F172A),
            ],
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                    ),
                    border: Border.all(color: Colors.white30, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22D3EE).withValues(alpha: 0.25),
                        blurRadius: 26,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Estudiante DuocDev',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ingeniería Informática • Duoc UC',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusBadge(
                      label: 'Nivel $level',
                      color: const Color(0xFF22D3EE),
                      icon: Icons.trending_up_rounded,
                    ),
                    StatusBadge(
                      label: '${progressService.xp} XP',
                      color: const Color(0xFFF59E0B),
                      icon: Icons.bolt_rounded,
                    ),
                    StatusBadge(
                      label: '${progressService.streakDays} días',
                      color: const Color(0xFFFB923C),
                      icon: Icons.local_fire_department,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progreso de nivel',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: const Color(0xFF22D3EE),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progressService.xpIntoLevel}/${ProgressService.xpPerLevel} XP hacia el próximo nivel',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionTitle('Resumen'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              const MetricTile(
                icon: Icons.menu_book_rounded,
                label: 'Cursos iniciados',
                value: '6',
                color: Color(0xFF22D3EE),
              ),
              MetricTile(
                icon: Icons.check_circle_rounded,
                label: 'Lecciones',
                value: '${progressService.completedCount}',
                color: const Color(0xFF22C55E),
              ),
              MetricTile(
                icon: Icons.quiz_rounded,
                label: 'Desafíos',
                value: '${progressService.completedExercises.length}',
                color: const Color(0xFF8B5CF6),
              ),
              MetricTile(
                icon: Icons.psychology_alt_rounded,
                label: 'Práctica IA',
                value: '${progressService.generatedExercisesCompleted.length}',
                color: const Color(0xFFFB923C),
              ),
              MetricTile(
                icon: Icons.workspace_premium_rounded,
                label: 'Insignias',
                value: '$earnedBadges',
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SectionTitle('Insignias'),
          const SizedBox(height: 12),
          DuocCard(
            radius: 24,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badges
                  .map(
                    (badge) => StatusBadge(
                      label: badge.title,
                      color: badge.earned
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF64748B),
                      icon: badge.earned
                          ? Icons.check_circle_outline
                          : Icons.lock_outline,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          HeroPanel(
            icon: Icons.admin_panel_settings_rounded,
            colors: const [Color(0xFF581C87), Color(0xFF0F172A)],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modo profesor',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sube material académico, genera ejercicios y publica práctica inteligente para estudiantes.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Entrar como profesor',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherDashboardScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
