import 'package:duocdev/data/demo_material_data.dart';
import 'package:duocdev/models/academic_material.dart';

class MaterialService {
  final List<AcademicMaterial> _materials = [...demoMaterials];
  List<AcademicMaterial> getMaterials() => List.unmodifiable(_materials);
  void saveMaterial(AcademicMaterial material) => _materials.insert(0, material);
  void deleteMaterial(String id) => _materials.removeWhere((m) => m.id == id);
  void updateMaterial(AcademicMaterial updated) {
    final i = _materials.indexWhere((m) => m.id == updated.id);
    if (i >= 0) _materials[i] = updated;
  }
}

final materialService = MaterialService();
