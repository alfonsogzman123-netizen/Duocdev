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
    'python': 'Python Básico',
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
    final text = rawTextController.text.trim();
    if (titleController.text.trim().isEmpty ||
        selectedCourseId == null ||
        text.length < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El material debe tener suficiente contenido para generar ejercicios.',
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
      rawText: text,
      summary: text.substring(0, text.length.clamp(0, 100).toInt()),
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
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          materialService.lastInfoMessage ??
              'Material guardado. Si backend no estaba disponible, quedó pendiente de sincronización.',
        ),
      ),
    );

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
    final chars = rawTextController.text.trim().length;
    final enough = chars >= 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Subir material')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.upload_file_rounded,
            colors: const [
              Color(0xFF0E7490),
              Color(0xFF312E81),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                StatusBadge(
                  label: 'Material académico',
                  color: Color(0xFF22D3EE),
                  icon: Icons.article_outlined,
                ),
                SizedBox(height: 14),
                Text(
                  'Sube una guía para generar práctica',
                  style: TextStyle(
                    fontSize: 31,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'En esta versión MVP el material se ingresa como texto. Próximamente PDF, DOCX y PPTX.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Datos del material',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del material',
                  ),
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
                  decoration: const InputDecoration(
                    labelText: 'Tags separados por coma',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Contenido académico',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    StatusBadge(
                      label: '$chars caracteres',
                      color: enough
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFFB923C),
                      icon: enough
                          ? Icons.check_circle_rounded
                          : Icons.info_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Agrega una explicación, guía o resumen de clase. Mientras más contexto, mejores ejercicios.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
                TextField(
                  controller: rawTextController,
                  minLines: 8,
                  maxLines: 12,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Pega aquí el contenido de la clase...',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          HeroPanel(
            icon: Icons.auto_fix_high_rounded,
            colors: const [Color(0xFF581C87), Color(0xFF0F172A)],
            padding: const EdgeInsets.all(18),
            child: const Text(
              'La IA/demo generará preguntas iniciales. El profesor siempre revisa, aprueba y publica antes de que el estudiante practique.',
              style: TextStyle(color: Colors.white70, height: 1.35),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Guardar material', onPressed: () => _save()),
          const SizedBox(height: 8),
          PrimaryButton(
            label: 'Guardar y generar ejercicios',
            onPressed: () => _save(goGenerate: true),
          ),
        ],
      ),
    );
  }
}
