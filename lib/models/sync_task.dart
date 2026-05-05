enum SyncTaskType { createMaterial, generateExercises, approveExercise, publishExercise }
enum SyncTaskStatus { pending, synced, failed }

class SyncTask {
  final String id;
  final SyncTaskType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final SyncTaskStatus status;
  final String? errorMessage;

  const SyncTask({required this.id, required this.type, required this.payload, required this.createdAt, this.status = SyncTaskStatus.pending, this.errorMessage});

  SyncTask copyWith({SyncTaskStatus? status, String? errorMessage}) => SyncTask(
        id: id,
        type: type,
        payload: payload,
        createdAt: createdAt,
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}
