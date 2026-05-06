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
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Profesor')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Panel Profesor',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Convierte material real de clase en práctica personalizada.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 14),
          _BackendStatusCard(
            connected: backendConnected,
            pending: pending,
            onSync: _syncNow,
          ),
          const SizedBox(height: 14),
          const DuocCard(
            radius: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.tips_and_updates_rounded, color: Color(0xFF22D3EE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sube una guía o contenido de clase para generar práctica personalizada con IA.',
                    style: TextStyle(fontSize: 17, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetricCard(
                title: 'Materiales',
                value: '${stats.materials}',
                icon: Icons.article_outlined,
                color: const Color(0xFF22D3EE),
              ),
              _MetricCard(
                title: 'Generados',
                value: '${stats.generated}',
                icon: Icons.auto_awesome,
                color: const Color(0xFF8B5CF6),
              ),
              _MetricCard(
                title: 'Aprobados',
                value: '${stats.approved}',
                icon: Icons.check_circle_outline,
                color: const Color(0xFF22C55E),
              ),
              _MetricCard(
                title: 'Publicados',
                value: '${stats.published}',
                icon: Icons.publish_rounded,
                color: const Color(0xFFFB923C),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Acciones rápidas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionCard(
                title: 'Subir material',
                icon: Icons.upload_file_rounded,
                onTap: () => _open(const MaterialUploadScreen()),
              ),
              _ActionCard(
                title: 'Generar ejercicios',
                icon: Icons.auto_fix_high_rounded,
                onTap: () => _open(const GeneratedExercisesScreen()),
              ),
              _ActionCard(
                title: 'Banco de ejercicios',
                icon: Icons.fact_check_rounded,
                onTap: () => _open(const GeneratedExercisesScreen()),
              ),
              _ActionCard(
                title: 'Ver materiales',
                icon: Icons.folder_open_rounded,
                onTap: () => _open(const MaterialListScreen()),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Últimos materiales',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (materialService.cachedMaterials.isEmpty)
            const DuocCard(child: Text('Todavía no hay materiales cargados.'))
          else
            ...materialService.cachedMaterials
                .take(3)
                .map(
                  (material) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DuocCard(
                      radius: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${material.subject} • ${material.unitName}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
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

class _BackendStatusCard extends StatelessWidget {
  const _BackendStatusCard({
    required this.connected,
    required this.pending,
    required this.onSync,
  });

  final bool? connected;
  final int pending;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    final isConnected = connected == true;
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isConnected
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
                color: isConnected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFFB923C),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isConnected
                      ? 'Backend: Conectado'
                      : 'Backend: No disponible / Modo demo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pendientes de sincronizar: $pending',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            pending == 0 ? 'Sincronización al día' : 'Hay cambios pendientes',
            style: TextStyle(
              color: pending == 0
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFFB923C),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onSync,
            icon: const Icon(Icons.sync_rounded),
            label: const Text('Sincronizar ahora'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      child: DuocCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      child: DuocCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF22D3EE), size: 30),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
