import 'package:duocdev/data/course_data.dart';

class BadgeProgress {
  const BadgeProgress({
    required this.title,
    required this.description,
    required this.earned,
  });

  final String title;
  final String description;
  final bool earned;
}

class ProgressService {
  static const int xpPerLevel = 120;
  static const int dailyGoalXp = 50;
  static const int dailyGoalLessons = 1;
  static const int dailyGoalExercises = 3;

  final Set<String> completedLessons = {};
  final Set<String> completedExercises = {};
  final Set<String> generatedExercisesCompleted = {};
  int xp = 210;
  int streakDays = 7;

  int get totalLessons =>
      courses.fold(0, (sum, course) => sum + course.lessons.length);
  int get completedCount => completedLessons.length;
  double get overallProgress =>
      totalLessons == 0 ? 0 : completedCount / totalLessons;
  int get level => (xp ~/ xpPerLevel) + 1;
  int get xpIntoLevel => xp % xpPerLevel;
  double get levelProgress => xpIntoLevel / xpPerLevel;
  int get todayXp => xp.clamp(0, dailyGoalXp).toInt();
  double get dailyGoalProgress => todayXp / dailyGoalXp;
  String get dailyGoalLabel =>
      'Completa $dailyGoalLessons lección, resuelve $dailyGoalExercises ejercicios y gana $dailyGoalXp XP.';

  List<String> get badges => badgeCatalog
      .where((badge) => badge.earned)
      .map((badge) => badge.title)
      .toList();

  List<BadgeProgress> get badgeCatalog => [
    BadgeProgress(
      title: 'Primera lección',
      description: 'Completa tu primera microlección.',
      earned: completedCount >= 1 || xp >= 30,
    ),
    BadgeProgress(
      title: 'Primer desafío',
      description: 'Resuelve un desafío de ruta.',
      earned: completedExercises.isNotEmpty || completedCount >= 1 || xp >= 30,
    ),
    BadgeProgress(
      title: 'Primer ejercicio generado',
      description: 'Practica con material publicado por profesor.',
      earned: generatedExercisesCompleted.isNotEmpty,
    ),
    const BadgeProgress(
      title: 'Python inicial',
      description: 'Avanza por los fundamentos de Python.',
      earned: true,
    ),
    const BadgeProgress(
      title: 'Git básico',
      description: 'Comprende commits y control de versiones.',
      earned: true,
    ),
    BadgeProgress(
      title: 'Racha 7 días',
      description: 'Mantén constancia semanal.',
      earned: streakDays >= 7,
    ),
    BadgeProgress(
      title: 'Material dominado',
      description: 'Completa práctica generada desde una guía docente.',
      earned: generatedExercisesCompleted.length >= 3,
    ),
    BadgeProgress(
      title: 'Práctica inteligente completada',
      description: 'Resuelve al menos un ejercicio publicado por profesor.',
      earned: generatedExercisesCompleted.isNotEmpty,
    ),
    const BadgeProgress(
      title: 'Tutor IA usado',
      description: 'Apóyate con el tutor para estudiar un concepto.',
      earned: true,
    ),
  ];

  bool isCompleted(String lessonKey) => completedLessons.contains(lessonKey);
  bool isLessonCompleted(String courseId, String lessonId) =>
      completedLessons.contains('$courseId:$lessonId');
  bool isGeneratedExerciseCompleted(String exerciseId) =>
      generatedExercisesCompleted.contains(exerciseId);

  bool completeLesson(String lessonKey, bool correct) {
    final isNew = completedLessons.add(lessonKey);
    if (isNew) {
      completedExercises.add(lessonKey);
      xp += correct ? 30 : 10;
    }
    return isNew;
  }

  void completeExercise(String exerciseId, int rewardXp) {
    if (completedExercises.add(exerciseId)) xp += rewardXp;
  }

  void completeGeneratedExercise(String exerciseId, int rewardXp) {
    if (generatedExercisesCompleted.add(exerciseId)) xp += rewardXp;
  }

  double courseProgress(String courseId) {
    final course = courses.firstWhere(
      (item) => item.id == courseId,
      orElse: () => courses.first,
    );
    if (course.lessons.isEmpty) return 0;
    final done = course.lessons
        .where((lesson) => isLessonCompleted(course.id, lesson.id))
        .length;
    return done / course.lessons.length;
  }
}

final progressService = ProgressService();
