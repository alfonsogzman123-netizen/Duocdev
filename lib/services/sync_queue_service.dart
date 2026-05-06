import 'package:duocdev/models/sync_task.dart';

class SyncQueueService {
  final List<SyncTask> _tasks = [];

  void addTask(SyncTask task) => _tasks.insert(0, task);
  List<SyncTask> getPendingTasks() => _tasks
      .where(
        (t) =>
            t.status == SyncTaskStatus.pending ||
            t.status == SyncTaskStatus.failed,
      )
      .toList();
  int get pendingCount => getPendingTasks().length;
  int get failedCount =>
      _tasks.where((t) => t.status == SyncTaskStatus.failed).length;

  void markSynced(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i >= 0) {
      _tasks[i] = _tasks[i].copyWith(status: SyncTaskStatus.synced);
    }
  }

  void markFailed(String id, String message) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i >= 0) {
      _tasks[i] = _tasks[i].copyWith(
        status: SyncTaskStatus.failed,
        errorMessage: message,
      );
    }
  }

  void clearSynced() =>
      _tasks.removeWhere((t) => t.status == SyncTaskStatus.synced);

  Future<int> trySyncAll(
    Future<bool> Function(SyncTask task) syncHandler,
  ) async {
    var synced = 0;
    for (final task in List<SyncTask>.from(getPendingTasks())) {
      final ok = await syncHandler(task);
      if (ok) {
        markSynced(task.id);
        synced++;
      } else {
        markFailed(task.id, 'No se pudo sincronizar. Intenta nuevamente.');
      }
    }
    clearSynced();
    return synced;
  }
}

final syncQueueService = SyncQueueService();
