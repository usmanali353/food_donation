import 'dart:convert';

class UserData {
  UserData({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.role,
    this.userId
  });

  String? name;
  String? phone;
  String? email;
  String? password;
  String? userId;
  int? role;

  static UserData userFromJson(String str) => UserData.fromJson(json.decode(str));

  static String userToJson(UserData data) => json.encode(data.toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    role: json["role"],
      userId: json["userId"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
    "role": role,
  };
}
