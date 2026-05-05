import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/services/api_service.dart';

class ExerciseGenerationService {
  final List<GeneratedExercise> _exercises = [];
  List<GeneratedExercise> get all => List.unmodifiable(_exercises);
  String? lastInfoMessage;

  Future<List<GeneratedExercise>> generateExercisesFromMaterial({required AcademicMaterial material, required int count, required ExerciseDifficulty difficulty}) async {
    try {
      final data = await apiService.post('/materials/${material.id}/generate-exercises', {
        'quantity': count,
        'difficulty': difficulty.name,
        'type': 'multiple_choice',
      }) as Map<String, dynamic>;
      final exercises = ((data['exercises'] as List<dynamic>?) ?? [])
          .map((item) => _fromJson(item as Map<String, dynamic>))
          .toList();
      _exercises.insertAll(0, exercises);
      lastInfoMessage = 'Ejercicios generados desde backend.';
      return exercises;
    } catch (_) {
      final words = material.rawText.split(' ').where((e) => e.length > 3).take(count).toList();
      final generated = List.generate(count, (i) {
        final token = words.isNotEmpty ? words[i % words.length] : 'concepto';
        return GeneratedExercise(
          id: 'gen_${DateTime.now().millisecondsSinceEpoch}_$i',
          materialId: material.id,
          courseId: material.courseId,
          type: ExerciseType.multipleChoice,
          difficulty: difficulty,
          question: 'Según el material, ¿qué describe mejor "$token"?',
          options: const ['Definición principal del contenido', 'Un error común sin relación', 'Un comando inexistente', 'Un tema fuera de contexto'],
          correctIndex: 0,
          explanation: 'Se basa directamente en el contenido académico proporcionado por el profesor.',
          xpReward: 20,
          createdAt: DateTime.now(),
        );
      });
      _exercises.insertAll(0, generated);
      lastInfoMessage = 'Usando generación demo local.';
      return generated;
    }
  }

  Future<List<GeneratedExercise>> getExercises() async {
    try {
      final data = await apiService.get('/exercises') as List<dynamic>;
      _exercises
        ..clear()
        ..addAll(data.map((item) => _fromJson(item as Map<String, dynamic>)));
      return all;
    } catch (_) {
      return all;
    }
  }

  Future<void> approveExercise(String id) async {
    try {
      await apiService.post('/exercises/$id/approve', {});
    } catch (_) {}
    _mutate(id, (exercise) => exercise.copyWith(approved: true));
  }

  Future<void> publishExercise(String id) async {
    try {
      await apiService.post('/exercises/$id/publish', {});
    } catch (_) {}
    _mutate(id, (exercise) => exercise.copyWith(published: true, approved: true));
  }


  List<GeneratedExercise> publishedForCourse(String courseId) =>
      _exercises.where((exercise) => exercise.courseId == courseId && exercise.published).toList();

  Future<List<GeneratedExercise>> getPublishedExercisesForCourse(String courseId) async {
    try {
      final data = await apiService.get('/courses/$courseId/exercises') as List<dynamic>;
      return data.map((item) => _fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return _exercises.where((exercise) => exercise.courseId == courseId && exercise.published).toList();
    }
  }

  void updateExercise(GeneratedExercise exercise) => _mutate(exercise.id, (_) => exercise);

  GeneratedExercise _fromJson(Map<String, dynamic> json) => GeneratedExercise(
        id: json['id'] as String,
        materialId: json['materialId'] as String,
        courseId: json['courseId'] as String,
        type: ExerciseType.multipleChoice,
        difficulty: ExerciseDifficulty.values.firstWhere(
          (value) => value.name == (json['difficulty'] ?? 'basic'),
          orElse: () => ExerciseDifficulty.basic,
        ),
        question: json['question'] as String,
        options: ((json['options'] as List<dynamic>?) ?? []).map((e) => e.toString()).toList(),
        correctIndex: (json['correctIndex'] as num?)?.toInt() ?? 0,
        explanation: (json['explanation'] as String?) ?? '',
        xpReward: (json['xpReward'] as num?)?.toInt() ?? 20,
        approved: json['approved'] == true,
        published: json['published'] == true,
        createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ?? DateTime.now(),
      );

  void _mutate(String id, GeneratedExercise Function(GeneratedExercise e) mapper) {
    final index = _exercises.indexWhere((exercise) => exercise.id == id);
    if (index >= 0) _exercises[index] = mapper(_exercises[index]);
  }
}

final exerciseGenerationService = ExerciseGenerationService();
