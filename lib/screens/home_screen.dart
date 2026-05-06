import 'dart:math' as math;

import 'package:duocdev/screens/teacher/teacher_dashboard_screen.dart';
import 'package:duocdev/services/api_service.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/progress_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onGoToRoute,
    required this.onGoToPractice,
    required this.onGoToTutor,
    required this.onGoToProfile,
  });

  final VoidCallback onGoToRoute;
  final VoidCallback onGoToPractice;
  final VoidCallback onGoToTutor;
  final VoidCallback onGoToProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? _backendConnected;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final connected = await apiService.healthCheck();
    await exerciseGenerationService.getExercises();
    if (mounted) setState(() => _backendConnected = connected);
  }

  @override
  Widget build(BuildContext context) {
    final practice = exerciseGenerationService.studentPracticeExercises();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          _WelcomeHero(
            connected: _backendConnected,
            onStart: widget.onGoToRoute,
            onTeacher: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
            ),
          ),
          const SizedBox(height: 18),
          const _ProgressDashboard(),
          const SizedBox(height: 18),
          const SectionTitle('Misiones de hoy'),
          const SizedBox(height: 12),
          const _DailyMissions(),
          const SizedBox(height: 22),
          SectionTitle(
            'Continúa aprendiendo',
            trailing: StatusBadge(
              label: '75%',
              color: const Color(0xFF22D3EE),
              icon: Icons.trending_up_rounded,
            ),
          ),
          const SizedBox(height: 12),
          _ContinueLearningCard(onTap: widget.onGoToRoute),
          const SizedBox(height: 22),
          _SmartPracticeSpotlight(
            count: practice.length,
            onTap: widget.onGoToPractice,
          ),
          const SizedBox(height: 22),
          _QuickAccessSection(
            onGoToRoute: widget.onGoToRoute,
            onGoToPractice: widget.onGoToPractice,
            onGoToTutor: widget.onGoToTutor,
            onGoToProfile: widget.onGoToProfile,
            onGoToTeacher: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({
    required this.connected,
    required this.onStart,
    required this.onTeacher,
  });

  final bool? connected;
  final VoidCallback onStart;
  final VoidCallback onTeacher;

  @override
  Widget build(BuildContext context) {
    return HeroPanel(
      icon: Icons.auto_awesome,
      colors: const [Color(0xFF4C1D95), Color(0xFF0E7490), Color(0xFF0F172A)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.code_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DuocDev',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Aprende programación con práctica inteligente',
                      style: TextStyle(color: Colors.white70, height: 1.2),
                    ),
                  ],
                ),
              ),
              if (connected != null)
                StatusBadge(
                  label: connected! ? 'Backend' : 'Demo',
                  color: connected!
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFB923C),
                  icon: connected!
                      ? Icons.cloud_done_rounded
                      : Icons.cloud_off_rounded,
                ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Hola, Estudiante',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 6),
          const Text(
            'Cursos, Tutor IA y ejercicios generados desde material académico.',
            style: TextStyle(
              fontSize: 29,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BenefitPill('Rutas guiadas', Icons.route_rounded),
              _BenefitPill('Ejercicios inteligentes', Icons.psychology_alt),
              _BenefitPill('Contenido de clase', Icons.school_rounded),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(label: 'Comenzar', onPressed: onStart),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: 'Ver modo profesor',
                onPressed: onTeacher,
                icon: const Icon(Icons.admin_panel_settings_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitPill extends StatelessWidget {
  const _BenefitPill(this.label, this.icon);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ProgressDashboard extends StatelessWidget {
  const _ProgressDashboard();

  @override
  Widget build(BuildContext context) {
    final progress = progressService.levelProgress;
    final overall = progressService.overallProgress.clamp(0.18, 1.0);

    return DuocCard(
      radius: 26,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progreso de aprendizaje',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nivel ${progressService.level}',
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Programador en formación',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: const Color(0xFF22D3EE),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '${progressService.xpIntoLevel}/${ProgressService.xpPerLevel} XP para subir de nivel',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusBadge(
                      label: '${progressService.streakDays} días',
                      color: const Color(0xFFFB923C),
                      icon: Icons.local_fire_department,
                    ),
                    StatusBadge(
                      label: '${ProgressService.dailyGoalXp} XP meta',
                      color: const Color(0xFF8B5CF6),
                      icon: Icons.flag_rounded,
                    ),
                    StatusBadge(
                      label: '${(overall * 100).round()}% ruta',
                      color: const Color(0xFF22C55E),
                      icon: Icons.timeline_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 98,
            height: 98,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -math.pi / 2,
                  child: SizedBox(
                    width: 98,
                    height: 98,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 9,
                      color: const Color(0xFF60A5FA),
                      backgroundColor: const Color(0xFF334155),
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
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

class _DailyMissions extends StatelessWidget {
  const _DailyMissions();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _MissionCard(
          icon: Icons.menu_book_rounded,
          title: 'Completa una lección',
          subtitle: 'Microlearning',
          done: true,
          color: Color(0xFF22C55E),
        ),
        _MissionCard(
          icon: Icons.quiz_rounded,
          title: 'Resuelve 3 ejercicios',
          subtitle: '2 de 3 listos',
          done: false,
          color: Color(0xFF22D3EE),
        ),
        _MissionCard(
          icon: Icons.auto_awesome,
          title: 'Pregunta al Tutor IA',
          subtitle: 'Refuerza dudas',
          done: false,
          color: Color(0xFFFB923C),
        ),
      ],
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool done;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: DuocCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const Spacer(),
                Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: done ? const Color(0xFF22C55E) : Colors.white38,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900, height: 1.15),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.code_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Python Básico',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Última lección: Funciones y módulos',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 10,
              color: Color(0xFF8B5CF6),
              backgroundColor: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Continúa con una sesión corta y gana XP para mantener tu racha.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _SmartPracticeSpotlight extends StatelessWidget {
  const _SmartPracticeSpotlight({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HeroPanel(
      icon: Icons.psychology_alt_rounded,
      colors: const [Color(0xFF164E63), Color(0xFF1E1B4B), Color(0xFF0F172A)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusBadge(
            label: 'Práctica inteligente',
            color: Color(0xFF22D3EE),
            icon: Icons.auto_awesome,
          ),
          const SizedBox(height: 12),
          const Text(
            'Ejercicios generados desde material docente',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            count == 0
                ? 'Usa contenido demo mientras el profesor publica nuevas actividades.'
                : '$count ejercicios publicados para practicar con contexto real de clase.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Practicar ahora', onPressed: onTap),
        ],
      ),
    );
  }
}

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection({
    required this.onGoToRoute,
    required this.onGoToPractice,
    required this.onGoToTutor,
    required this.onGoToProfile,
    required this.onGoToTeacher,
  });

  final VoidCallback onGoToRoute;
  final VoidCallback onGoToPractice;
  final VoidCallback onGoToTutor;
  final VoidCallback onGoToProfile;
  final VoidCallback onGoToTeacher;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Acceso rápido'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            MetricTile(
              icon: Icons.route_rounded,
              label: 'Cursos',
              value: 'Ruta',
              color: const Color(0xFF8B5CF6),
              onTap: onGoToRoute,
            ),
            MetricTile(
              icon: Icons.psychology_alt_rounded,
              label: 'Práctica',
              value: 'IA',
              color: const Color(0xFF22D3EE),
              onTap: onGoToPractice,
            ),
            MetricTile(
              icon: Icons.auto_awesome,
              label: 'Tutor IA',
              value: 'Ayuda',
              color: const Color(0xFFFB923C),
              onTap: onGoToTutor,
            ),
            MetricTile(
              icon: Icons.person_rounded,
              label: 'Perfil',
              value: 'XP',
              color: const Color(0xFF22C55E),
              onTap: onGoToProfile,
            ),
            MetricTile(
              icon: Icons.admin_panel_settings_rounded,
              label: 'Panel profesor',
              value: 'Docente',
              color: const Color(0xFFF472B6),
              onTap: onGoToTeacher,
            ),
          ],
        ),
      ],
    );
  }
}
