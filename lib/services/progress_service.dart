import 'package:duocdev/data/course_data.dart';

class ProgressService {
  final Set<String> completedLessons = {};
  int xp = 0;

  int get totalLessons => courses.fold(0, (sum, c) => sum + c.lessons.length);
  int get completedCount => completedLessons.length;
  double get overallProgress => totalLessons == 0 ? 0 : completedCount / totalLessons;
  int get level => (xp ~/ 120) + 1;

  bool isCompleted(String lessonKey) => completedLessons.contains(lessonKey);

  bool completeLesson(String lessonKey, bool correct) {
    final isNew = completedLessons.add(lessonKey);
    if (isNew) {
      xp += correct ? 30 : 10;
    }
    return isNew;
  }
}

final progressService = ProgressService();
