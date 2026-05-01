class Lesson {
  final String id;
  final String title;
  final String content;
  final String code;
  final Challenge challenge;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.code,
    required this.challenge,
  });
}

class Challenge {
  final String question;
  final List<String> options;
  final int correctIndex;

  const Challenge({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class Course {
  final String id;
  final String title;
  final String level;
  final String description;
  final List<Lesson> lessons;

  const Course({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
    required this.lessons,
  });
}
