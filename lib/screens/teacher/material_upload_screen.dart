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
  final titleController = TextEditingController();
  final unitController = TextEditingController();
  final rawTextController = TextEditingController();
  final tagsController = TextEditingController();

  String? selectedCourseId;
  final courses = const {
    'logica': 'Lógica de Programación',
    'python': 'Python',
    'git': 'Git y GitHub',
    'web': 'Desarrollo Web',
    'java': 'Java',
    'sql': 'SQL',
    'cpp': 'C++',
  };

  @override
  void dispose() {
    titleController.dispose();
    unitController.dispose();
    rawTextController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> _save({bool goGenerate = false}) async {
    if (titleController.text.trim().isEmpty ||
        selectedCourseId == null ||
        rawTextController.text.trim().length < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Título, curso y contenido (mínimo 100 caracteres) son obligatorios.',
          ),
        ),
      );
      return;
    }

    final material = AcademicMaterial(
      id: 'mat_${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim(),
      subject: courses[selectedCourseId]!,
      courseId: selectedCourseId!,
      unitName: unitController.text.trim().isEmpty
          ? 'Unidad general'
          : unitController.text.trim(),
      teacherName: 'Profesor DuocDev',
      createdAt: DateTime.now(),
      sourceType: MaterialSourceType.text,
      rawText: rawTextController.text.trim(),
      summary: rawTextController.text.trim().substring(0, 100),
      tags: tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      status: MaterialStatus.processed,
    );

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await materialService.saveMaterial(material);
    if (!mounted) return;
    if (materialService.lastInfoMessage != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(materialService.lastInfoMessage!)),
      );
    }

    if (goGenerate) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              GeneratedExercisesScreen(preselectedMaterialId: material.id),
        ),
      );
      return;
    }

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir material')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DuocCard(
            radius: 22,
            child: Text(
              'En esta versión MVP, el material se ingresa como texto. Próximamente se podrán subir PDF, DOCX y PPTX.',
            ),
          ),
          const SizedBox(height: 10),
          DuocCard(
            radius: 24,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedCourseId,
                  decoration: const InputDecoration(labelText: 'Curso'),
                  items: courses.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedCourseId = value),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unidad o tema'),
                ),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(labelText: 'Tags (coma)'),
                ),
                TextField(
                  controller: rawTextController,
                  minLines: 7,
                  maxLines: 9,
                  decoration: const InputDecoration(
                    labelText: 'Contenido académico',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: 'Guardar material', onPressed: () => _save()),
          const SizedBox(height: 8),
          PrimaryButton(
            label: 'Generar ejercicios con IA',
            onPressed: () => _save(goGenerate: true),
          ),
        ],
      ),
    );
  }
}
