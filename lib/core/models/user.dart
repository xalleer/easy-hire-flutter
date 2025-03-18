class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> workLocations;
  final List<String> skills;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.workLocations,
    required this.skills,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      workLocations: List<String>.from(json['workLocations'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'workLocations': workLocations,
      'skills': skills,
    };
  }
}
