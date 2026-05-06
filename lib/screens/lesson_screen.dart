import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/challenge_screen.dart';
import 'package:duocdev/screens/tutor_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.course, required this.lesson});

  final Course course;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final index = course.lessons.indexOf(lesson) + 1;
    final progress = course.lessons.isEmpty
        ? 0.0
        : index / course.lessons.length;
    final lessonContext =
        '${course.title} > ${lesson.title}\n${lesson.content}\nEjemplo:\n${lesson.code}';

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
        children: [
          HeroPanel(
            icon: Icons.menu_book_rounded,
            colors: const [
              Color(0xFF1D4ED8),
              Color(0xFF312E81),
              Color(0xFF0F172A),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  label: 'Lección $index de ${course.lessons.length}',
                  color: const Color(0xFFFFFFFF),
                  icon: Icons.timeline_rounded,
                ),
                const SizedBox(height: 14),
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Microlección breve, práctica y conectada con el desafío.',
                  style: TextStyle(color: Colors.white70, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DuocCard(
            radius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.flag_rounded, color: Color(0xFF22C55E)),
                    SizedBox(width: 8),
                    Text(
                      'Qué aprenderás',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._learningGoals(lesson).map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF22C55E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _LessonBlock(
            icon: Icons.lightbulb_rounded,
            title: 'Explicación breve',
            color: const Color(0xFF22D3EE),
            child: Text(
              lesson.content,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Ejemplo de código'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Text(
              lesson.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 17,
                color: Color(0xFF67E8F9),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LessonBlock(
            icon: Icons.school_rounded,
            title: 'Tip del profesor',
            color: const Color(0xFFFB923C),
            child: Text(
              lesson.tip,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _LessonBlock(
            icon: Icons.summarize_rounded,
            title: 'Mini resumen',
            color: const Color(0xFF8B5CF6),
            child: Text(
              'Primero entiende el concepto, luego mira el ejemplo y finalmente responde el desafío aplicándolo en un caso concreto.',
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TutorScreen(
                  initialMode: TutorMode.lesson,
                  initialQuestion:
                      'Resume esta lección y dame un ejemplo corto.',
                  lessonContext: lessonContext,
                ),
              ),
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Preguntar al Tutor IA'),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Continuar al desafío',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChallengeScreen(course: course, lesson: lesson),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonBlock extends StatelessWidget {
  const _LessonBlock({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DuocCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

List<String> _learningGoals(Lesson lesson) {
  return [
    'Comprender ${lesson.title.toLowerCase()} en un contexto de programación real.',
    'Leer un ejemplo corto y reconocer sus partes importantes.',
    'Responder un desafío con feedback inmediato y una pista útil.',
  ];
}
