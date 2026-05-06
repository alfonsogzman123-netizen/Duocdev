import 'dart:math' as math;

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
  });

  final VoidCallback onGoToRoute;
  final VoidCallback onGoToPractice;
  final VoidCallback onGoToTutor;

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
        padding: const EdgeInsets.all(22),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, Estudiante 👋',
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Continúa tu ruta de programación',
                      style: TextStyle(
                        fontSize: 32,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (_backendConnected != null)
                _ConnectionPill(connected: _backendConnected!),
            ],
          ),
          const SizedBox(height: 18),
          const _PremiumProgressCard(),
          const SizedBox(height: 16),
          const _DailyMissionCard(),
          const SizedBox(height: 22),
          const SectionTitle('Continúa aprendiendo'),
          const SizedBox(height: 12),
          DuocCard(
            onTap: widget.onGoToRoute,
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: const Icon(
                        Icons.code_rounded,
                        color: Color(0xFF22D3EE),
                        size: 30,
                      ),
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Funciones, módulos y práctica guiada',
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
                    minHeight: 9,
                    color: Color(0xFF8B5CF6),
                    backgroundColor: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '75% completado',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          if (practice.isNotEmpty) ...[
            const SizedBox(height: 22),
            _SmartPracticeHomeCard(
              count: practice.length,
              onTap: widget.onGoToPractice,
            ),
          ],
          const SizedBox(height: 22),
          _QuickAccessSection(
            onGoToRoute: widget.onGoToRoute,
            onGoToPractice: widget.onGoToPractice,
            onGoToTutor: widget.onGoToTutor,
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _Stat(
                icon: Icons.local_fire_department,
                title: 'Racha',
                value: '7 días',
                color: Color(0xFFFB923C),
              ),
              _Stat(
                icon: Icons.emoji_events,
                title: 'Insignias',
                value: '7',
                color: Color(0xFFF59E0B),
              ),
              _Stat(
                icon: Icons.auto_awesome,
                title: 'Prácticas IA',
                value: '4',
                color: Color(0xFF22D3EE),
              ),
              _Stat(
                icon: Icons.bar_chart_rounded,
                title: 'Meta diaria',
                value: '50 XP',
                color: Color(0xFF8B5CF6),
              ),
            ],
          ),
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
  });

  final VoidCallback onGoToRoute;
  final VoidCallback onGoToPractice;
  final VoidCallback onGoToTutor;

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
            _QuickAction(
              icon: Icons.menu_book_rounded,
              label: 'Cursos',
              color: const Color(0xFF8B5CF6),
              onTap: onGoToRoute,
            ),
            _QuickAction(
              icon: Icons.psychology_alt_rounded,
              label: 'Práctica',
              color: const Color(0xFF22D3EE),
              onTap: onGoToPractice,
            ),
            _QuickAction(
              icon: Icons.auto_awesome,
              label: 'Tutor IA',
              color: const Color(0xFFFB923C),
              onTap: onGoToTutor,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: DuocCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionPill extends StatelessWidget {
  const _ConnectionPill({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: connected ? const Color(0xFF052E16) : const Color(0xFF431407),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: connected ? const Color(0xFF22C55E) : const Color(0xFFFB923C),
        ),
      ),
      child: Text(
        connected ? 'Conectado' : 'Modo demo',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PremiumProgressCard extends StatelessWidget {
  const _PremiumProgressCard();

  @override
  Widget build(BuildContext context) {
    final progress = progressService.levelProgress;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF111827), Color(0xFF172554)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
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
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Programador en formación',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 17),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: const Color(0xFF22D3EE),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progressService.xpIntoLevel} / ${ProgressService.xpPerLevel} XP hacia el próximo nivel',
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Racha ${progressService.streakDays} días • Meta diaria ${ProgressService.dailyGoalXp} XP',
                  style: const TextStyle(color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 94,
            height: 94,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -math.pi / 2,
                  child: SizedBox(
                    width: 94,
                    height: 94,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      color: const Color(0xFF60A5FA),
                      backgroundColor: const Color(0xFF334155),
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
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

class _DailyMissionCard extends StatelessWidget {
  const _DailyMissionCard();

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_rounded, color: Color(0xFFFB923C)),
              SizedBox(width: 8),
              Text(
                'Meta de hoy',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            progressService.dailyGoalLabel,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressService.dailyGoalProgress,
              minHeight: 9,
              color: const Color(0xFFFB923C),
              backgroundColor: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${progressService.todayXp} / ${ProgressService.dailyGoalXp} XP completados hoy',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SmartPracticeHomeCard extends StatelessWidget {
  const _SmartPracticeHomeCard({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF22D3EE)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Práctica generada por profesor',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count ejercicios publicados desde material académico. Practica con contenido real de clase.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 14),
          PrimaryButton(label: 'Practicar ahora', onPressed: onTap),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
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
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
