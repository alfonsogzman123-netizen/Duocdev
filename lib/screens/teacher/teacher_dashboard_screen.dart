import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/screens/teacher/material_list_screen.dart';
import 'package:duocdev/screens/teacher/material_upload_screen.dart';
import 'package:duocdev/services/api_service.dart';
import 'package:duocdev/services/material_service.dart';
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
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    final ok = await apiService.healthCheck();
    if (mounted) setState(() => backendConnected = ok);
  }

  @override
  Widget build(BuildContext context) {
    final stats = teacherService.getTeacherDashboardStats();
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Profesor')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Panel Profesor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            backendConnected == true ? 'Backend: Conectado' : 'Backend: No disponible / Modo demo',
            style: TextStyle(color: backendConnected == true ? Colors.greenAccent : Colors.orangeAccent),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 10, runSpacing: 10, children: [
            _metric('Materiales', '${stats.materials}'),
            _metric('Generados', '${stats.generated}'),
            _metric('Aprobados', '${stats.approved}'),
          ]),
          const SizedBox(height: 14),
          PrimaryButton(label: 'Subir material', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialUploadScreen()))),
          const SizedBox(height: 8),
          PrimaryButton(label: 'Generar ejercicios', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratedExercisesScreen()))),
          const SizedBox(height: 8),
          PrimaryButton(label: 'Ver materiales', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialListScreen()))),
          const SizedBox(height: 14),
          const Text('Últimos materiales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          FutureBuilder(
            future: materialService.getMaterials(),
            builder: (context, snapshot) {
              final materials = (snapshot.data ?? const []).take(3).toList();
              return Column(
                children: materials
                    .map((material) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: DuocCard(child: Text('${material.title}\n${material.subject} • ${material.unitName}')),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _metric(String title, String value) => SizedBox(width: 110, child: DuocCard(padding: const EdgeInsets.all(12), child: Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), Text(title, style: const TextStyle(color: Colors.white70))])));
}
