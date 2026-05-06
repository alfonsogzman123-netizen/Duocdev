import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/models/sync_task.dart';
import 'package:duocdev/services/api_service.dart';
import 'package:duocdev/services/local_cache_service.dart';
import 'package:duocdev/services/sync_queue_service.dart';

class MaterialService {
  String? lastInfoMessage;
  List<AcademicMaterial> get cachedMaterials =>
      localCacheService.getCachedMaterials();

  Future<List<AcademicMaterial>> getMaterials() async {
    try {
      final data = await apiService.get('/materials') as List<dynamic>;
      final materials = data
          .map((item) => _fromJson(item as Map<String, dynamic>))
          .toList();
      localCacheService.cacheMaterials(materials);
      lastInfoMessage = 'Datos cargados desde backend.';
      return localCacheService.getCachedMaterials();
    } catch (_) {
      lastInfoMessage = 'Usando datos locales.';
      return localCacheService.getCachedMaterials();
    }
  }

  Future<AcademicMaterial?> getMaterialById(String id) async {
    try {
      final data =
          await apiService.get('/materials/$id') as Map<String, dynamic>;
      return _fromJson(data);
    } catch (_) {
      return localCacheService
          .getCachedMaterials()
          .where((material) => material.id == id)
          .firstOrNull;
    }
  }

  Future<void> saveMaterial(AcademicMaterial material) async {
    try {
      await apiService.post('/materials', {
        'id': material.id,
        'title': material.title,
        'subject': material.subject,
        'courseId': material.courseId,
        'unitName': material.unitName,
        'teacherName': material.teacherName,
        'rawText': material.rawText,
        'tags': material.tags,
      });
      await getMaterials();
      lastInfoMessage = 'Material guardado en backend.';
    } catch (_) {
      localCacheService.addMaterial(material);
      syncQueueService.addTask(
        SyncTask(
          id: 'sync_mat_${DateTime.now().millisecondsSinceEpoch}',
          type: SyncTaskType.createMaterial,
          payload: {
            'id': material.id,
            'title': material.title,
            'subject': material.subject,
            'courseId': material.courseId,
            'unitName': material.unitName,
            'teacherName': material.teacherName,
            'rawText': material.rawText,
            'tags': material.tags,
          },
          createdAt: DateTime.now(),
        ),
      );
      lastInfoMessage =
          'Backend no disponible. Material guardado localmente y pendiente de sincronización.';
    }
  }

  AcademicMaterial _fromJson(Map<String, dynamic> json) {
    final rawText = (json['rawText'] as String?) ?? '';
    return AcademicMaterial(
      id: json['id'] as String,
      title: json['title'] as String,
      subject:
          (json['subject'] as String?) ??
          (json['courseId'] as String? ?? 'General'),
      courseId: json['courseId'] as String,
      unitName: (json['unitName'] as String?) ?? 'Unidad general',
      teacherName: (json['teacherName'] as String?) ?? 'Profesor DuocDev',
      createdAt:
          DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
      sourceType: MaterialSourceType.text,
      rawText: rawText,
      summary: rawText.substring(0, rawText.length.clamp(0, 100).toInt()),
      tags: ((json['tags'] as List<dynamic>?) ?? [])
          .map((item) => item.toString())
          .toList(),
      status: MaterialStatus.processed,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

final materialService = MaterialService();
