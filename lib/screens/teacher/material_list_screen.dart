import 'package:duocdev/screens/teacher/material_detail_screen.dart';
import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class MaterialListScreen extends StatelessWidget {
  const MaterialListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final list = materialService.cachedMaterials;
    return Scaffold(appBar: AppBar(title: const Text('Material académico')), body: ListView(padding: const EdgeInsets.all(20), children: list.map((m) => Padding(padding: const EdgeInsets.only(bottom: 10), child: DuocCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), Text('${m.subject} • ${m.status.name}'), Wrap(spacing: 6, children: m.tags.map((t) => Chip(label: Text(t))).toList()), Row(children: [TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => MaterialDetailScreen(material: m))), child: const Text('Ver detalle')), TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratedExercisesScreen(preselectedMaterialId: m.id))), child: const Text('Generar ejercicios'))])])))).toList()));
  }
}
