class UserModel {
  final String image;
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.image,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      image: json['image'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
