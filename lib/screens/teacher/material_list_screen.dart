import 'package:duocdev/screens/teacher/generated_exercises_screen.dart';
import 'package:duocdev/screens/teacher/material_detail_screen.dart';
import 'package:duocdev/services/material_service.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class MaterialListScreen extends StatelessWidget {
  const MaterialListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = materialService.cachedMaterials;
    return Scaffold(
      appBar: AppBar(title: const Text('Material académico')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Material académico',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            const DuocCard(child: Text('Todavía no hay material cargado.'))
          else
            ...list.map(
              (material) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DuocCard(
                  radius: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${material.subject} • ${material.status.name}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: material.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MaterialDetailScreen(material: material),
                              ),
                            ),
                            child: const Text('Ver detalle'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GeneratedExercisesScreen(
                                  preselectedMaterialId: material.id,
                                ),
                              ),
                            ),
                            child: const Text('Generar ejercicios'),
                          ),
                        ],
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
}
