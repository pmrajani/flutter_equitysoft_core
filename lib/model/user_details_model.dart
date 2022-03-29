import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserDetailsModel userDetailsModelFromJson(String str) =>
    UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) =>
    json.encode(data.createToJson());

class UserDetailsModel {
  UserDetailsModel({
    this.userId = "",
    this.profilePhoto = "",
    this.name = "",
    this.email = "",
    this.status = 0,
    this.token = "",
    this.phoneNumber = "",
    this.countryCode = "",
    this.age = "",
    this.createdAt,
    this.updatedAt,
  });

  String userId;
  String profilePhoto;
  String name;
  String email;
  int status;
  String token;
  String phoneNumber;
  String countryCode;
  String age;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        userId: json["user_id"] ?? "",
        profilePhoto: json["profile_photo"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        status: json["status"] ?? 0,
        token: json["token"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        countryCode: json["country_code"] ?? "",
        age: json["age"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> createToJson() => {
        "user_id": userId,
        "profile_photo": profilePhoto,
        "name": name,
        "email": email,
        "status": status,
        "token": token,
        "phone_number": phoneNumber,
        "country_code": countryCode,
        "age": age,
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
      };

  Map<String, dynamic> updateUserTokenToJson() => {
        "token": token,
        "updated_at": Timestamp.now(),
      };

  Map<String, dynamic> upUStatusToJson() => {
        "status": status,
        "updated_at": Timestamp.now(),
      };
}
