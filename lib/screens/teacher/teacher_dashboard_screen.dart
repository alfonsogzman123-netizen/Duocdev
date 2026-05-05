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
    if (backendConnected != true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo sincronizar. Backend no disponible.')));
      return;
    }
    final synced = await syncQueueService.trySyncAll((task) async {
      try {
        if (task.type == SyncTaskType.createMaterial) {
          await apiService.post('/materials', task.payload);
        } else if (task.type == SyncTaskType.approveExercise) {
          await apiService.post('/exercises/${task.payload['exerciseId']}/approve', {});
        } else if (task.type == SyncTaskType.publishExercise) {
          await apiService.post('/exercises/${task.payload['exerciseId']}/publish', {});
        }
        return true;
      } catch (_) {
        return false;
      }
    });
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(synced > 0 ? 'Sincronización completada.' : 'No se pudo sincronizar. Intenta nuevamente.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = teacherService.getTeacherDashboardStats();
    final pending = syncQueueService.pendingCount;
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Profesor')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Panel Profesor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(backendConnected == true ? 'Backend: Conectado' : 'Backend: No disponible / Modo demo', style: TextStyle(color: backendConnected == true ? Colors.greenAccent : Colors.orangeAccent)),
        Text('Pendientes de sincronizar: $pending', style: const TextStyle(color: Colors.white70)),
        Text(pending == 0 ? 'Sincronización al día' : 'Hay cambios pendientes', style: TextStyle(color: pending == 0 ? Colors.greenAccent : Colors.orangeAccent)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: _syncNow, child: const Text('Sincronizar ahora')),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: [_metric('Materiales', '${stats.materials}'), _metric('Generados', '${stats.generated}'), _metric('Aprobados', '${stats.approved}')]),
        const SizedBox(height: 14),
        PrimaryButton(label: 'Subir material', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialUploadScreen())).then((_) => _refresh())),
        const SizedBox(height: 8),
        PrimaryButton(label: 'Generar ejercicios', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratedExercisesScreen())).then((_) => _refresh())),
        const SizedBox(height: 8),
        PrimaryButton(label: 'Ver materiales', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialListScreen())).then((_) => _refresh())),
        const SizedBox(height: 14),
        const Text('Últimos materiales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        ...materialService.cachedMaterials.take(3).map((m) => Padding(padding: const EdgeInsets.only(top: 8), child: DuocCard(child: Text('${m.title}\n${m.subject} • ${m.unitName}')))),
      ]),
    );
  }

  Widget _metric(String title, String value) => SizedBox(width: 110, child: DuocCard(padding: const EdgeInsets.all(12), child: Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), Text(title, style: const TextStyle(color: Colors.white70))])));
}
