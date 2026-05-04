import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/result_screen.dart';
import 'package:duocdev/widgets/app_cards.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key, required this.course, required this.lesson});
  final Course course;
  final Lesson lesson;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int? selected;
  @override
  Widget build(BuildContext context) {
    final challenge = widget.lesson.challenge;
    return Scaffold(appBar: AppBar(title: const Text('Desafío')), body: ListView(padding: const EdgeInsets.all(20), children: [
      DuocCard(child: Text(challenge.question, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))),
      const SizedBox(height: 12),
      ...List.generate(challenge.options.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: DuocCard(onTap: () => setState(() => selected = i), child: Row(children: [Expanded(child: Text(challenge.options[i], style: const TextStyle(fontSize: 18))), Icon(selected == i ? Icons.check_circle : Icons.circle_outlined, color: selected == i ? const Color(0xFF8B5CF6) : Colors.white54)])))),
      const SizedBox(height: 20),
      PrimaryButton(label: 'Responder', onPressed: selected == null ? null : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(course: widget.course, lesson: widget.lesson, selected: selected!)))),
    ]));
  }
}
