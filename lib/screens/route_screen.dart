import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/course_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(20), children: [
        const Center(child: Text('Cursos', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800))),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          children: ['Todos', 'Básico', 'Intermedio', 'Avanzado']
              .map((e) => Chip(label: Text(e), backgroundColor: e == 'Todos' ? const Color(0xFF8B5CF6) : const Color(0xFF1E293B)))
              .toList(),
        ),
        const SizedBox(height: 14),
        ...courses.asMap().entries.map((entry) {
          final index = entry.key;
          final c = entry.value;
          final locked = c.status == CourseStatus.locked;
          final progress = _progress(c.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: DuocCard(
              radius: 24,
              onTap: locked ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: c))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  alignment: Alignment.center,
                  child: Text(_emoji(c.id), style: const TextStyle(fontSize: 36)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${index + 1}. ${c.title}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(c.level, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: LinearProgressIndicator(value: progress, minHeight: 8, color: _color(c.id), backgroundColor: const Color(0xFF334155)),
                      ),
                      const SizedBox(width: 10),
                      Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(locked ? Icons.lock_rounded : Icons.check_circle_outline_rounded, color: locked ? Colors.white54 : const Color(0xFF22C55E), size: 30),
                ),
              ]),
            ),
          );
        }),
      ]),
    );
  }

  String _emoji(String id) => switch (id) {'logica' => '{}', 'python' => '🐍', 'git' => '🔀', 'web' => '🌐', 'java' => '☕', 'sql' => '🛢️', _ => '🔒'};
  double _progress(String id) => {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}.containsKey(id) ? {'logica': 1.0, 'python': 0.75, 'git': 0.6, 'web': 0.25}[id]! : 0.0;
  Color _color(String id) => {'logica': const Color(0xFF22C55E), 'python': const Color(0xFF8B5CF6), 'git': const Color(0xFFFB923C), 'web': const Color(0xFF38BDF8)}[id] ?? const Color(0xFF334155);
}
