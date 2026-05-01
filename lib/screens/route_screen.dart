import 'package:duocdev/data/course_data.dart';
import 'package:duocdev/screens/course_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  Color _colorFor(int i) => [const Color(0xFF39E58C), const Color(0xFF8B5CF6), const Color(0xFFFF6B3D), const Color(0xFF4DA8FF)][i % 4];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final c = courses[index];
          final p = index == 0 ? 1.0 : index == 1 ? 0.75 : index == 2 ? 0.6 : 0.25;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: c))),
              child: DuocCard(
                child: Row(children: [
                  CircleAvatar(radius: 26, backgroundColor: _colorFor(index).withOpacity(0.2), child: Icon(Icons.school, color: _colorFor(index))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${index + 1}. ${c.title}', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), Text('Nivel ${c.level.replaceAll('Nivel ', '')}', style: const TextStyle(color: Color(0xFF98A4C7))), const SizedBox(height: 8), DuocProgressBar(value: p, color: _colorFor(index))])),
                  const SizedBox(width: 8),
                  Text('${(p * 100).toInt()}%')
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
