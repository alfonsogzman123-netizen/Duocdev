import 'package:duocdev/data/demo_material_data.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/generated_exercise.dart';

class LocalCacheService {
  // TODO: reemplazar por Hive/SQLite/SharedPreferences para persistencia real.
  final List<AcademicMaterial> _materials = [...demoMaterials];
  final List<GeneratedExercise> _exercises = [];

  void cacheMaterials(List<AcademicMaterial> materials) {
    _materials
      ..clear()
      ..addAll(materials);
  }

  List<AcademicMaterial> getCachedMaterials() => List.unmodifiable(_materials);
  void addMaterial(AcademicMaterial material) => _materials.insert(0, material);

  void cacheExercises(List<GeneratedExercise> exercises) {
    _exercises
      ..clear()
      ..addAll(exercises);
  }

  List<GeneratedExercise> getCachedExercises() => List.unmodifiable(_exercises);
  void addExercises(List<GeneratedExercise> exercises) => _exercises.insertAll(0, exercises);

  void updateExercise(GeneratedExercise exercise) {
    final i = _exercises.indexWhere((e) => e.id == exercise.id);
    if (i >= 0) {
      _exercises[i] = exercise;
    } else {
      _exercises.insert(0, exercise);
    }
  }

  List<GeneratedExercise> getPublishedExercisesForCourse(String courseId) =>
      _exercises.where((e) => e.courseId == courseId && e.published).toList();
}

final localCacheService = LocalCacheService();
