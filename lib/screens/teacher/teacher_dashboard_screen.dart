import 'package:duocdev/models/sync_task.dart';
import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/screens/teacher/material_list_screen.dart';
import 'package:duocdev/screens/teacher/material_upload_screen.dart';
import 'package:duocdev/services/api_service.dart';
import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/services/sync_queue_service.dart';
import 'package:duocdev/services/teacher_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  bool? backendConnected;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await materialService.getMaterials();
    await exerciseGenerationService.getExercises();
    final ok = await apiService.healthCheck();
    if (mounted) setState(() => backendConnected = ok);
  }

  Future<void> _syncNow() async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await apiService.healthCheck();
    if (mounted) setState(() => backendConnected = ok);
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo sincronizar. Backend no disponible.'),
        ),
      );
      return;
    }

    final synced = await syncQueueService.trySyncAll((task) async {
      try {
        if (task.type == SyncTaskType.createMaterial) {
          await apiService.post('/materials', task.payload);
        } else if (task.type == SyncTaskType.generateExercises) {
          await apiService.post(
            '/materials/${task.payload['materialId']}/generate-exercises',
            {
              'quantity': task.payload['quantity'],
              'difficulty': task.payload['difficulty'],
              'type': 'multiple_choice',
            },
          );
        } else if (task.type == SyncTaskType.approveExercise) {
          await apiService.post(
            '/exercises/${task.payload['exerciseId']}/approve',
            {},
          );
        } else if (task.type == SyncTaskType.publishExercise) {
          await apiService.post(
            '/exercises/${task.payload['exerciseId']}/publish',
            {},
          );
        }
        return true;
      } catch (_) {
        return false;
      }
    });

    if (!mounted) return;
    await _refresh();
    if (!mounted) return;
    final remaining = syncQueueService.pendingCount;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          remaining == 0
              ? 'Sincronización al día.'
              : synced > 0
              ? 'Sincronización parcial. Quedan $remaining pendientes.'
              : 'No se pudo sincronizar. Intenta nuevamente.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = teacherService.getTeacherDashboardStats();
    final pending = syncQueueService.pendingCount;
    final connected = backendConnected == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Panel Profesor')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
          children: [
            HeroPanel(
              icon: Icons.admin_panel_settings_rounded,
              colors: const [
                Color(0xFF581C87),
                Color(0xFF164E63),
                Color(0xFF0F172A),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(
                    label: connected
                        ? 'Backend: Conectado'
                        : 'Backend: Modo demo',
                    color: connected
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFFB923C),
                    icon: connected
                        ? Icons.cloud_done_rounded
                        : Icons.cloud_off_rounded,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Panel Profesor',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Convierte guías y contenidos reales en práctica personalizada con IA.',
                    style: TextStyle(color: Colors.white70, height: 1.35),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatusBadge(
                          label: pending == 0
                              ? 'Sincronización al día'
                              : '$pending pendientes',
                          color: pending == 0
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFFB923C),
                          icon: pending == 0
                              ? Icons.check_circle_rounded
                              : Icons.sync_problem_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: _syncNow,
                        icon: const Icon(Icons.sync_rounded),
                        label: const Text('Sincronizar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MetricTile(
                  icon: Icons.article_outlined,
                  label: 'Materiales',
                  value: '${stats.materials}',
                  color: const Color(0xFF22D3EE),
                ),
                MetricTile(
                  icon: Icons.auto_awesome,
                  label: 'Generados',
                  value: '${stats.generated}',
                  color: const Color(0xFF8B5CF6),
                ),
                MetricTile(
                  icon: Icons.check_circle_outline,
                  label: 'Aprobados',
                  value: '${stats.approved}',
                  color: const Color(0xFF22C55E),
                ),
                MetricTile(
                  icon: Icons.publish_rounded,
                  label: 'Publicados',
                  value: '${stats.published}',
                  color: const Color(0xFFFB923C),
                ),
              ],
            ),
            const SizedBox(height: 20),
            HeroPanel(
              icon: Icons.tips_and_updates_rounded,
              colors: const [Color(0xFF0E7490), Color(0xFF0F172A)],
              padding: const EdgeInsets.all(18),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recomendación IA',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sube una guía para crear práctica personalizada. En este MVP el material se ingresa como texto; próximamente PDF, DOCX y PPTX.',
                    style: TextStyle(color: Colors.white70, height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle('Acciones rápidas'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ActionCard(
                  title: 'Subir material',
                  subtitle: 'Texto académico',
                  icon: Icons.upload_file_rounded,
                  color: const Color(0xFF22D3EE),
                  onTap: () => _open(const MaterialUploadScreen()),
                ),
                _ActionCard(
                  title: 'Banco de ejercicios',
                  subtitle: 'Revisar y publicar',
                  icon: Icons.fact_check_rounded,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => _open(const GeneratedExercisesScreen()),
                ),
                _ActionCard(
                  title: 'Ver materiales',
                  subtitle: 'Guías cargadas',
                  icon: Icons.folder_open_rounded,
                  color: const Color(0xFF22C55E),
                  onTap: () => _open(const MaterialListScreen()),
                ),
                _ActionCard(
                  title: 'Generar práctica',
                  subtitle: 'IA/demo',
                  icon: Icons.auto_fix_high_rounded,
                  color: const Color(0xFFFB923C),
                  onTap: () => _open(const GeneratedExercisesScreen()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionTitle('Últimos materiales'),
            const SizedBox(height: 10),
            if (materialService.cachedMaterials.isEmpty)
              const EmptyState(
                icon: Icons.article_outlined,
                title: 'Todavía no hay materiales',
                message: 'Carga una guía o contenido de clase para comenzar.',
              )
            else
              ...materialService.cachedMaterials
                  .take(4)
                  .map(
                    (material) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DuocCard(
                        radius: 20,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.article_outlined,
                              color: Color(0xFF22D3EE),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${material.subject} • ${material.unitName}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(Widget screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _refresh());
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: DuocCard(
        radius: 22,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
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
