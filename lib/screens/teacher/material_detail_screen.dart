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
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.article_outlined,
            colors: const [
              Color(0xFF0E7490),
              Color(0xFF1E1B4B),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: material.subject,
                  color: const Color(0xFF22D3EE),
                  icon: Icons.menu_book_rounded,
                ),
                const SizedBox(height: 14),
                Text(
                  material.title,
                  style: const TextStyle(
                    fontSize: 31,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  material.unitName,
                  style: const TextStyle(color: Colors.white70, height: 1.35),
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
                  'Resumen',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(material.summary, style: const TextStyle(height: 1.35)),
                const SizedBox(height: 12),
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
          const SizedBox(height: 14),
          DuocCard(
            radius: 24,
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(top: 8),
              title: const Text(
                'Contenido completo',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              children: [
                Text(
                  material.rawText,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
