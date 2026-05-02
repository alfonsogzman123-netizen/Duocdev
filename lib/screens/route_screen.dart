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
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final c = courses[index];
          final locked = c.status == CourseStatus.locked;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: locked ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: c))),
              child: Opacity(
                opacity: locked ? 0.6 : 1,
                child: DuocCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('${c.level} • ${c.description}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('Lecciones: ${c.lessons.length} • Estado: ${c.status.name}'),
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
