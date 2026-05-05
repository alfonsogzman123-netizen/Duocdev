enum UserRole { student, teacher }

class UserModel {
  final String name;
  final String career;
  final UserRole role;
  const UserModel({required this.name, required this.career, required this.role});
}
