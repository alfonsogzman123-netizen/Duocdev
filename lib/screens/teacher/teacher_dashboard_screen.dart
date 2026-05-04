import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/screens/teacher/material_list_screen.dart';
import 'package:duocdev/screens/teacher/material_upload_screen.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/services/teacher_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = teacherService.getTeacherDashboardStats();
    return Scaffold(appBar: AppBar(title: const Text('Panel Profesor')), body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Panel Profesor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _metric('Materiales', '${s.materials}'), _metric('Generados', '${s.generated}'), _metric('Aprobados', '${s.approved}'),
      ]),
      const SizedBox(height: 14),
      PrimaryButton(label: 'Subir material', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialUploadScreen()))),
      const SizedBox(height: 8),
      PrimaryButton(label: 'Generar ejercicios', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratedExercisesScreen()))),
      const SizedBox(height: 8),
      PrimaryButton(label: 'Ver materiales', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialListScreen()))),
      const SizedBox(height: 14),
      const Text('Últimos materiales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      ...materialService.getMaterials().take(3).map((m) => Padding(padding: const EdgeInsets.only(top: 8), child: DuocCard(child: Text('${m.title}\n${m.subject} • ${m.unitName}')))),
    ]));
  }

  Widget _metric(String t, String v) => SizedBox(width: 110, child: DuocCard(padding: const EdgeInsets.all(12), child: Column(children: [Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), Text(t, style: const TextStyle(color: Colors.white70))])));
}
