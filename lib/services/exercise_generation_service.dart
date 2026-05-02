import 'dart:math';

import 'package:duocdev/config/app_config.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/services/ai_service.dart';

class ExerciseGenerationService {
  final List<GeneratedExercise> _exercises = [];
  List<GeneratedExercise> get all => List.unmodifiable(_exercises);

  Future<List<GeneratedExercise>> generateExercisesFromMaterial({required AcademicMaterial material, required int count, required ExerciseDifficulty difficulty}) async {
    if (AppConfig.hasApiKey) {
      // TODO backend seguro: en producción mover esta llamada a backend proxy y no desde app móvil.
      try {
        await AIService().askTutor(question: 'Genera $count ejercicios', context: material.rawText);
      } catch (_) {}
    }
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
        options: ['Definición principal del contenido', 'Un error común sin relación', 'Un comando inexistente', 'Un tema fuera de contexto'],
        correctIndex: 0,
        explanation: 'Se basa directamente en el contenido académico proporcionado por el profesor.',
        xpReward: 20 + i * 5,
        createdAt: DateTime.now(),
      );
    });
    _exercises.insertAll(0, generated);
    return generated;
  }

  void approveExercise(String id) => _mutate(id, (e) => e.copyWith(approved: true));
  void publishExercise(String id) => _mutate(id, (e) => e.copyWith(published: true, approved: true));
  void updateExercise(GeneratedExercise exercise) => _mutate(exercise.id, (_) => exercise);

  List<GeneratedExercise> publishedForCourse(String courseId) => _exercises.where((e) => e.courseId == courseId && e.published).toList();

  void _mutate(String id, GeneratedExercise Function(GeneratedExercise e) mapper) {
    final i = _exercises.indexWhere((e) => e.id == id);
    if (i >= 0) _exercises[i] = mapper(_exercises[i]);
  }
}

final exerciseGenerationService = ExerciseGenerationService();
