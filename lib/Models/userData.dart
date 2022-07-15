import 'dart:convert';

import 'package:food_donation/Models/Rating.dart';

class UserData {
  UserData({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.role,
    this.userId,
    this.rating,
    this.isBlocked
  });

  String? name;
  String? phone;
  String? email;
  String? password;
  String? userId;
  int? role;
  bool? isBlocked;
  List<dynamic>? rating=[];
  static List<Rating> ratingListFromJson(String str) => List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));
  static UserData userFromJson(String str) => UserData.fromJson(json.decode(str));

  static String userToJson(UserData data) => json.encode(data.toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    role: json["role"],
      userId: json["userId"],
     rating: json["rating"],
    isBlocked: json["isBlocked"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
    "role": role,
    "isBlocked":isBlocked
  };
}
