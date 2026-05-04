import 'package:duocdev/data/course_data.dart';

class ProgressService {
  final Set<String> completedLessons = {};
  final Set<String> completedExercises = {};
  final Set<String> generatedExercisesCompleted = {};
  int xp = 0;
  int streakDays = 7;

  int get totalLessons => courses.fold(0, (sum, c) => sum + c.lessons.length);
  int get completedCount => completedLessons.length;
  double get overallProgress => totalLessons == 0 ? 0 : completedCount / totalLessons;
  int get level => (xp ~/ 120) + 1;
  List<String> get badges => [if (completedCount >= 1) 'Primera lección', if (streakDays >= 7) 'Racha 7 días', if (xp >= 300) 'Constancia'];

  bool isCompleted(String lessonKey) => completedLessons.contains(lessonKey);
  bool isLessonCompleted(String courseId, String lessonId) => completedLessons.contains('$courseId:$lessonId');

  bool completeLesson(String lessonKey, bool correct) {
    final isNew = completedLessons.add(lessonKey);
    if (isNew) xp += correct ? 30 : 10;
    return isNew;
  }

  void completeExercise(String exerciseId, int rewardXp) {
    if (completedExercises.add(exerciseId)) xp += rewardXp;
  }

  void completeGeneratedExercise(String exerciseId, int rewardXp) {
    if (generatedExercisesCompleted.add(exerciseId)) xp += rewardXp;
  }

  double courseProgress(String courseId) {
    final course = courses.firstWhere((c) => c.id == courseId, orElse: () => courses.first);
    if (course.lessons.isEmpty) return 0;
    final done = course.lessons.where((l) => isLessonCompleted(course.id, l.id)).length;
    return done / course.lessons.length;
  }
}

final progressService = ProgressService();
