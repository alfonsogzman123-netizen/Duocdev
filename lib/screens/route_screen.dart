import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/course_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Center(child: Text('Cursos', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800))),
      const SizedBox(height: 14),
      Wrap(spacing: 10, children: ['Todos', 'Básico', 'Intermedio', 'Avanzado'].map((e) => Chip(label: Text(e), backgroundColor: e == 'Todos' ? const Color(0xFF8B5CF6) : const Color(0xFF1E293B))).toList()),
      const SizedBox(height: 14),
      ...courses.asMap().entries.map((entry) {
        final index = entry.key;
        final c = entry.value;
        final locked = c.status == CourseStatus.locked;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DuocCard(
            onTap: locked ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: c))),
            child: Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)), alignment: Alignment.center, child: Text(_emoji(c.id), style: const TextStyle(fontSize: 28))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${index + 1}. ${c.title}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                Text(c.level, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _progress(c.id), minHeight: 8, color: _color(c.id), backgroundColor: const Color(0xFF334155)),
              ])),
              const SizedBox(width: 10),
              Column(children: [Icon(locked ? Icons.lock : Icons.check_circle_outline, color: locked ? Colors.white54 : const Color(0xFF22C55E)), Text('${(_progress(c.id) * 100).round()}%', style: const TextStyle(fontSize: 18))]),
            ]),
          ),
        );
      }),
    ]));
  }

  String _emoji(String id) => switch (id) {'logica' => '{}', 'python' => '🐍', 'git' => '🔀', 'web' => '🌐', 'java' => '☕', 'sql' => '🛢️', _ => '🔒'};
  double _progress(String id) => {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}.containsKey(id) ? {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}[id]! : 0.0;
  Color _color(String id) => {'logica': const Color(0xFF22C55E), 'python': const Color(0xFF8B5CF6), 'git': const Color(0xFFFB923C), 'web': const Color(0xFF38BDF8)}[id] ?? const Color(0xFF334155);
}
