import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class MaterialDetailScreen extends StatelessWidget {
  const MaterialDetailScreen({super.key, required this.material});

  final AcademicMaterial material;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle material')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${material.subject} • ${material.unitName}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(material.summary, style: const TextStyle(height: 1.35)),
                const SizedBox(height: 8),
                ExpansionTile(
                  title: const Text('Contenido completo'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(material.rawText),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: material.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Generar ejercicios',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GeneratedExercisesScreen(
                  preselectedMaterialId: material.id,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GeneratedExercisesScreen(
                  preselectedMaterialId: material.id,
                ),
              ),
            ),
            icon: const Icon(Icons.fact_check_rounded),
            label: const Text('Ver ejercicios asociados'),
          ),
        ],
      ),
    );
  }
}
