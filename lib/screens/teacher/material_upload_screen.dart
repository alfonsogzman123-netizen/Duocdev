import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class MaterialUploadScreen extends StatefulWidget {
  const MaterialUploadScreen({super.key});
  @override
  State<MaterialUploadScreen> createState() => _MaterialUploadScreenState();
}

class _MaterialUploadScreenState extends State<MaterialUploadScreen> {
  final title = TextEditingController(); final unit = TextEditingController(); final raw = TextEditingController(); final tags = TextEditingController();
  String? courseId;
  final courses = const {'logica': 'Lógica de Programación', 'python': 'Python', 'git': 'Git y GitHub', 'web': 'Desarrollo Web', 'java': 'Java', 'sql': 'SQL', 'cpp': 'C++'};

  void _save({bool goGenerate = false}) {
    if (title.text.trim().isEmpty || courseId == null || raw.text.trim().length < 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Título, curso y contenido (mínimo 100 caracteres) son obligatorios.'))); return;
    }
    final m = AcademicMaterial(id: 'mat_${DateTime.now().millisecondsSinceEpoch}', title: title.text.trim(), subject: courses[courseId]!, courseId: courseId!, unitName: unit.text.trim().isEmpty ? 'Unidad general' : unit.text.trim(), teacherName: 'Profesor DuocDev', createdAt: DateTime.now(), sourceType: MaterialSourceType.text, rawText: raw.text.trim(), summary: raw.text.trim().substring(0, 100), tags: tags.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(), status: MaterialStatus.processed);
    materialService.saveMaterial(m);
    if (goGenerate) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GeneratedExercisesScreen(preselectedMaterialId: m.id)));
    } else { Navigator.pop(context); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Subir material')), body: ListView(padding: const EdgeInsets.all(20), children: [
    const DuocCard(child: Text('En esta versión MVP, el material se ingresa como texto. Próximamente se podrán subir PDF, DOCX y PPTX.')),
    const SizedBox(height: 10),
    DuocCard(child: Column(children: [TextField(controller: title, decoration: const InputDecoration(labelText: 'Título')), DropdownButtonFormField<String>(value: courseId, decoration: const InputDecoration(labelText: 'Curso'), items: courses.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(), onChanged: (v) => setState(() => courseId = v)), TextField(controller: unit, decoration: const InputDecoration(labelText: 'Unidad o tema')), TextField(controller: tags, decoration: const InputDecoration(labelText: 'Tags (coma)')), TextField(controller: raw, minLines: 7, maxLines: 9, decoration: const InputDecoration(labelText: 'Contenido académico'))])),
    const SizedBox(height: 12), PrimaryButton(label: 'Guardar material', onPressed: _save), const SizedBox(height: 8), PrimaryButton(label: 'Generar ejercicios con IA', onPressed: () => _save(goGenerate: true)),
  ]));
}
