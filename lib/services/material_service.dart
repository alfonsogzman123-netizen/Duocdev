import 'package:duocdev/data/demo_material_data.dart';
import 'package:duocdev/models/academic_material.dart';
import 'package:duocdev/services/api_service.dart';

class MaterialService {
  final List<AcademicMaterial> _materials = [...demoMaterials];
  String? lastInfoMessage;
  List<AcademicMaterial> get cachedMaterials => List.unmodifiable(_materials);

  Future<List<AcademicMaterial>> getMaterials() async {
    try {
      final data = await apiService.get('/materials') as List<dynamic>;
      final backendMaterials = data.map((item) => _fromJson(item as Map<String, dynamic>)).toList();
      _materials
        ..clear()
        ..addAll(backendMaterials);
      lastInfoMessage = 'Materiales cargados desde backend.';
      return List.unmodifiable(_materials);
    } catch (_) {
      lastInfoMessage = 'Backend no disponible. Usando modo demo local.';
      return List.unmodifiable(_materials);
    }
  }

  Future<AcademicMaterial?> getMaterialById(String id) async {
    try {
      final data = await apiService.get('/materials/$id') as Map<String, dynamic>;
      return _fromJson(data);
    } catch (_) {
      return _materials.where((material) => material.id == id).firstOrNull;
    }
  }

  Future<void> saveMaterial(AcademicMaterial material) async {
    try {
      await apiService.post('/materials', {
        'title': material.title,
        'courseId': material.courseId,
        'unitName': material.unitName,
        'teacherName': material.teacherName,
        'rawText': material.rawText,
        'tags': material.tags,
      });
      await getMaterials();
      lastInfoMessage = 'Material guardado en backend.';
    } catch (_) {
      _materials.insert(0, material);
      lastInfoMessage = 'Backend no disponible. Se guardó en modo demo.';
    }
  }

  AcademicMaterial _fromJson(Map<String, dynamic> json) {
    return AcademicMaterial(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: (json['subject'] as String?) ?? (json['courseId'] as String? ?? 'General'),
      courseId: json['courseId'] as String,
      unitName: (json['unitName'] as String?) ?? 'Unidad general',
      teacherName: (json['teacherName'] as String?) ?? 'Profesor DuocDev',
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ?? DateTime.now(),
      sourceType: MaterialSourceType.text,
      rawText: (json['rawText'] as String?) ?? '',
      summary: (json['rawText'] as String?)?.substring(0, (((json['rawText'] as String?)?.length ?? 0) > 100 ? 100 : ((json['rawText'] as String?)?.length ?? 0))) ?? '',
      tags: ((json['tags'] as List<dynamic>?) ?? []).map((e) => e.toString()).toList(),
      status: MaterialStatus.processed,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

final materialService = MaterialService();
