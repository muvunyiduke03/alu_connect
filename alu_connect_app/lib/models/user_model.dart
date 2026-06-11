class UserModel {
  String id;
  String name;
  String email;
  String intake;
  String role;
  String bio;
  List<String> interests;

  UserModel({
    String? id,
    required this.name,
    required this.email,
    this.intake = 'S2024',
    this.role = 'Student',
    this.bio = '',
    List<String>? interests,
  })  : id = id ?? email,
        interests = interests ?? [];

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'A';
  }
}
