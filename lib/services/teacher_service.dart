import 'package:duocdev/services/exercise_generation_service.dart';
import 'package:duocdev/services/material_service.dart';

class TeacherDashboardStats {
  final int materials;
  final int generated;
  final int approved;
  final int published;
  const TeacherDashboardStats(
    this.materials,
    this.generated,
    this.approved,
    this.published,
  );
}

class TeacherService {
  TeacherDashboardStats getTeacherDashboardStats() {
    final all = exerciseGenerationService.all;
    return TeacherDashboardStats(
      materialService.cachedMaterials.length,
      all.length,
      all.where((exercise) => exercise.approved).length,
      all.where((exercise) => exercise.published).length,
    );
  }
}

final teacherService = TeacherService();
