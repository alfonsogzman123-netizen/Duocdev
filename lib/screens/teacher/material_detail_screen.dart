import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class MaterialDetailScreen extends StatelessWidget {
  const MaterialDetailScreen({super.key, required this.material});
  final AcademicMaterial material;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Detalle material')), body: ListView(padding: const EdgeInsets.all(20), children: [DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(material.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), Text('${material.subject} • ${material.unitName}'), const SizedBox(height: 8), Text(material.summary), const SizedBox(height: 8), ExpansionTile(title: const Text('Contenido completo'), children: [Padding(padding: const EdgeInsets.all(8), child: Text(material.rawText))]), Wrap(spacing: 6, children: material.tags.map((t) => Chip(label: Text(t))).toList())])), const SizedBox(height: 10), PrimaryButton(label: 'Generar ejercicios', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratedExercisesScreen(preselectedMaterialId: material.id))))]));
  }
}
