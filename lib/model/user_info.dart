class UserInfo {
  String name;
  String email;
  String image;
  int userId;

  UserInfo({
    required this.name,
    required this.email,
    required this.image,
    required this.userId,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      name: json['name'],
      image: json['image'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}
