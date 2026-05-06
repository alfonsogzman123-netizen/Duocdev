enum ExerciseType { multipleChoice, trueFalse, shortAnswer, codeQuestion }

enum ExerciseDifficulty { basic, intermediate, advanced }

class GeneratedExercise {
  final String id;
  final String materialId;
  final String courseId;
  final String? lessonId;
  final ExerciseType type;
  final ExerciseDifficulty difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int xpReward;
  final DateTime createdAt;
  final bool approved;
  final bool published;
  final String? sourceReference;

  const GeneratedExercise({
    required this.id,
    required this.materialId,
    required this.courseId,
    this.lessonId,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.xpReward,
    required this.createdAt,
    this.approved = false,
    this.published = false,
    this.sourceReference,
  });

  GeneratedExercise copyWith({
    String? question,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    int? xpReward,
    bool? approved,
    bool? published,
  }) => GeneratedExercise(
    id: id,
    materialId: materialId,
    courseId: courseId,
    lessonId: lessonId,
    type: type,
    difficulty: difficulty,
    question: question ?? this.question,
    options: options ?? this.options,
    correctIndex: correctIndex ?? this.correctIndex,
    explanation: explanation ?? this.explanation,
    xpReward: xpReward ?? this.xpReward,
    createdAt: createdAt,
    approved: approved ?? this.approved,
    published: published ?? this.published,
    sourceReference: sourceReference,
  );
}
