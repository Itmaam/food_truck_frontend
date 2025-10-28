class User {
  final int id;
  final String? email;
  final String? name;
  final String? imagePath;
  final int status;

  String get image => imagePath ?? 'https://api.dicebear.com/7.x/initials/png?seed=$name';
  bool get isActive => status == 1;

  User({required this.id, this.email, this.name, this.imagePath, this.status = 0});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String?,
      name: json['name'] as String?,
      imagePath: json['image_path'] as String?,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'image_path': imagePath, 'status': status};
  }
}
