import 'package:duocdev/data/demo_generated_exercise_data.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/generated_exercise.dart';
import 'package:duocdev/models/sync_task.dart';
import 'package:duocdev/services/api_service.dart';
import 'package:duocdev/services/local_cache_service.dart';
import 'package:duocdev/services/sync_queue_service.dart';

class ExerciseGenerationService {
  String? lastInfoMessage;
  List<GeneratedExercise> get all => localCacheService.getCachedExercises();

  Future<List<GeneratedExercise>> generateExercisesFromMaterial({
    required AcademicMaterial material,
    required int count,
    required ExerciseDifficulty difficulty,
  }) async {
    try {
      final data =
          await apiService.post(
                '/materials/${material.id}/generate-exercises',
                {
                  'quantity': count,
                  'difficulty': difficulty.name,
                  'type': 'multiple_choice',
                },
              )
              as Map<String, dynamic>;
      final exercises = ((data['exercises'] as List<dynamic>?) ?? [])
          .map((item) => _fromJson(item as Map<String, dynamic>))
          .toList();
      localCacheService.addExercises(exercises);
      lastInfoMessage = 'Ejercicios generados desde backend.';
      return exercises;
    } catch (_) {
      final words = material.rawText
          .split(' ')
          .where((word) => word.length > 3)
          .take(count)
          .toList();
      final generated = List.generate(count, (index) {
        final token = words.isNotEmpty
            ? words[index % words.length]
            : 'concepto';
        return GeneratedExercise(
          id: 'gen_${DateTime.now().millisecondsSinceEpoch}_$index',
          materialId: material.id,
          courseId: material.courseId,
          type: ExerciseType.multipleChoice,
          difficulty: difficulty,
          question: 'Según el material, ¿qué describe mejor "$token"?',
          options: const [
            'Definición principal del contenido',
            'Un error común sin relación',
            'Un comando inexistente',
            'Un tema fuera de contexto',
          ],
          correctIndex: 0,
          explanation:
              'Se basa directamente en el contenido académico proporcionado por el profesor.',
          xpReward: 20,
          createdAt: DateTime.now(),
        );
      });
      localCacheService.addExercises(generated);
      syncQueueService.addTask(
        SyncTask(
          id: 'sync_gen_${DateTime.now().millisecondsSinceEpoch}',
          type: SyncTaskType.generateExercises,
          payload: {
            'materialId': material.id,
            'quantity': count,
            'difficulty': difficulty.name,
          },
          createdAt: DateTime.now(),
        ),
      );
      lastInfoMessage =
          'Usando generación demo local. Pendiente de sincronización.';
      return generated;
    }
  }

  Future<List<GeneratedExercise>> getExercises() async {
    try {
      final data = await apiService.get('/exercises') as List<dynamic>;
      final exercises = data
          .map((item) => _fromJson(item as Map<String, dynamic>))
          .toList();
      localCacheService.cacheExercises(exercises);
      return localCacheService.getCachedExercises();
    } catch (_) {
      return localCacheService.getCachedExercises();
    }
  }

  Future<void> approveExercise(String id) async {
    try {
      await apiService.post('/exercises/$id/approve', {});
      _applyLocal(id, (exercise) => exercise.copyWith(approved: true));
    } catch (_) {
      _applyLocal(id, (exercise) => exercise.copyWith(approved: true));
      syncQueueService.addTask(
        SyncTask(
          id: 'sync_apr_${DateTime.now().millisecondsSinceEpoch}',
          type: SyncTaskType.approveExercise,
          payload: {'exerciseId': id},
          createdAt: DateTime.now(),
        ),
      );
      lastInfoMessage = 'Pendiente de sincronización.';
    }
  }

  Future<void> publishExercise(String id) async {
    try {
      await apiService.post('/exercises/$id/publish', {});
      _applyLocal(
        id,
        (exercise) => exercise.copyWith(published: true, approved: true),
      );
    } catch (_) {
      _applyLocal(
        id,
        (exercise) => exercise.copyWith(published: true, approved: true),
      );
      syncQueueService.addTask(
        SyncTask(
          id: 'sync_pub_${DateTime.now().millisecondsSinceEpoch}',
          type: SyncTaskType.publishExercise,
          payload: {'exerciseId': id},
          createdAt: DateTime.now(),
        ),
      );
      lastInfoMessage = 'Pendiente de sincronización.';
    }
  }

  List<GeneratedExercise> publishedForCourse(String courseId) =>
      localCacheService.getPublishedExercisesForCourse(courseId);

  List<GeneratedExercise> studentPracticeExercises({String? courseId}) {
    final published = localCacheService
        .getCachedExercises()
        .where(
          (exercise) =>
              exercise.published &&
              (courseId == null || exercise.courseId == courseId),
        )
        .toList();
    if (published.isNotEmpty) return published;
    return demoGeneratedExercises
        .where((exercise) => courseId == null || exercise.courseId == courseId)
        .toList();
  }

  bool hasStudentPractice({String? courseId}) =>
      studentPracticeExercises(courseId: courseId).isNotEmpty;

  Future<List<GeneratedExercise>> getPublishedExercisesForCourse(
    String courseId,
  ) async {
    try {
      final data =
          await apiService.get('/courses/$courseId/exercises') as List<dynamic>;
      return data
          .map((item) => _fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return localCacheService.getPublishedExercisesForCourse(courseId);
    }
  }

  void updateExercise(GeneratedExercise exercise) =>
      localCacheService.updateExercise(exercise);

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
    options: ((json['options'] as List<dynamic>?) ?? [])
        .map((item) => item.toString())
        .toList(),
    correctIndex: (json['correctIndex'] as num?)?.toInt() ?? 0,
    explanation: (json['explanation'] as String?) ?? '',
    xpReward: (json['xpReward'] as num?)?.toInt() ?? 20,
    approved: json['approved'] == true,
    published: json['published'] == true,
    createdAt:
        DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
        DateTime.now(),
    sourceReference: json['sourceReference'] as String?,
  );

  void _applyLocal(
    String id,
    GeneratedExercise Function(GeneratedExercise) mapper,
  ) {
    final exercise = localCacheService
        .getCachedExercises()
        .where((item) => item.id == id)
        .firstOrNull;
    if (exercise != null) localCacheService.updateExercise(mapper(exercise));
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

final exerciseGenerationService = ExerciseGenerationService();
