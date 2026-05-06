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
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.folder_open_rounded,
            colors: const [
              Color(0xFF0E7490),
              Color(0xFF312E81),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'Biblioteca docente',
                  color: Color(0xFF22D3EE),
                  icon: Icons.article_outlined,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Material académico',
                  style: TextStyle(
                    fontSize: 33,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${list.length} materiales disponibles para generar práctica inteligente.',
                  style: const TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (list.isEmpty)
            const EmptyState(
              icon: Icons.article_outlined,
              title: 'Todavía no hay material cargado',
              message: 'Sube una guía o contenido de clase para comenzar.',
            )
          else
            ...list.map(
              (material) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DuocCard(
                  radius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            color: Color(0xFF22D3EE),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              material.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusBadge(
                            label: material.subject,
                            color: const Color(0xFF8B5CF6),
                            icon: Icons.menu_book_rounded,
                          ),
                          StatusBadge(
                            label: material.unitName,
                            color: const Color(0xFF22D3EE),
                            icon: Icons.topic_rounded,
                          ),
                          StatusBadge(
                            label: _statusLabel(material.status.name),
                            color: const Color(0xFF22C55E),
                            icon: Icons.check_circle_outline,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: material.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MaterialDetailScreen(material: material),
                              ),
                            ),
                            icon: const Icon(Icons.visibility_outlined),
                            label: const Text('Ver detalle'),
                          ),
                          FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GeneratedExercisesScreen(
                                  preselectedMaterialId: material.id,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.auto_fix_high_rounded),
                            label: const Text('Generar ejercicios'),
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

  String _statusLabel(String status) {
    return switch (status) {
      'processed' => 'Procesado',
      'draft' => 'Borrador',
      'error' => 'Error',
      _ => status,
    };
  }
}
