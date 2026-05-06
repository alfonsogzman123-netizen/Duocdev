enum MaterialSourceType { text, pdfDemo, docDemo, slideDemo }

enum MaterialStatus { draft, processed, error }

class AcademicMaterial {
  final String id;
  final String title;
  final String subject;
  final String courseId;
  final String unitName;
  final String teacherName;
  final DateTime createdAt;
  final MaterialSourceType sourceType;
  final String rawText;
  final String summary;
  final List<String> tags;
  final MaterialStatus status;

  const AcademicMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.courseId,
    required this.unitName,
    required this.teacherName,
    required this.createdAt,
    required this.sourceType,
    required this.rawText,
    required this.summary,
    required this.tags,
    required this.status,
  });

  AcademicMaterial copyWith({MaterialStatus? status, String? summary}) =>
      AcademicMaterial(
        id: id,
        title: title,
        subject: subject,
        courseId: courseId,
        unitName: unitName,
        teacherName: teacherName,
        createdAt: createdAt,
        sourceType: sourceType,
        rawText: rawText,
        summary: summary ?? this.summary,
        tags: tags,
        status: status ?? this.status,
      );
}
