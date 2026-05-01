import 'package:duocdev/models/course_models.dart';
import 'package:duocdev/screens/result_screen.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  final Course course;
  final Lesson lesson;
  const ChallengeScreen({super.key, required this.course, required this.lesson});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    final challenge = widget.lesson.challenge;
    return Scaffold(
      appBar: AppBar(title: const Text('Desafío')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(challenge.question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...List.generate(challenge.options.length, (i) => RadioListTile<int>(value: i, groupValue: selected, onChanged: (v) => setState(() => selected = v), title: Text(challenge.options[i]))),
          const Spacer(),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: selected == null ? null : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(course: widget.course, lesson: widget.lesson, selected: selected!))), child: const Text('Responder')))
        ]),
      ),
    );
  }
}
