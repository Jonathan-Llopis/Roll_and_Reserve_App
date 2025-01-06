import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final String avatarId;
  final dynamic avatar;
  final double averageRaiting;

  UserModel(
      {required this.id,
      required this.email,
      required this.role,
      required this.name,
      required this.username,
      required this.avatar,
      required this.avatarId,
      required this.averageRaiting});

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
        id: userCredentials.user?.uid ?? "NO_ID",
        email: userCredentials.user?.email ?? "NO_EMAIL",
        name: userCredentials.user?.displayName ?? "NO_NAME",
        username: userCredentials.user?.displayName ?? "NO_NAME",
        role: 2,
        avatarId: "",
        avatar: File(""),
        averageRaiting: 0);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id_google'] ?? "",
        email: json['email'] ?? "",
        role: json['role'] ?? "",
        name: json['name'] ?? "",
        username: json['username'] ?? "",
        avatarId: json['avatar'] ?? "",
        avatar:File(""),
        averageRaiting: json['average_raiting'] ?? 0);
  }
  Map<String, dynamic> toJson() {
    return {
      'id_google': id,
      'email': email,
      'role': role,
      'name': name,
      'username': username,
    };
  }

  UserEntity toUserEntity(dynamic avatarFile) {
    return UserEntity(
        id: id,
        email: email,
        role: role,
        name: name,
        username: username,
        avatar: avatarFile,
        averageRaiting: averageRaiting);
  }
}
