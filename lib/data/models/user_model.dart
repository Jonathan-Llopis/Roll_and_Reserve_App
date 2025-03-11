import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_and_reserve/data/models/functions_for_models.dart';
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
  final bool? reserveConfirmation;
  List<int> notifications;

  UserModel(
      {required this.id,
      required this.email,
      required this.role,
      required this.name,
      required this.username,
      required this.avatar,
      required this.avatarId,
      required this.averageRaiting,
      required this.notifications,
      this.reserveConfirmation});

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
        id: userCredentials.user?.uid ?? "NO_ID",
        email: userCredentials.user?.email ?? "NO_EMAIL",
        name: userCredentials.user?.displayName ?? "NO_NAME",
        username: userCredentials.user?.displayName ?? "NO_NAME",
        role: 2,
        avatarId: "",
        avatar: File(""),
        averageRaiting: 0,
        notifications: [],);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id_google'] ?? "",
        email: json['email'] ?? "",
        role: json['role'] ?? 2,
        name: json['name'] ?? "",
        username: json['username'] ?? "",
        avatarId: json['avatar'] ?? "67c4bf09ae01906bd75ace8d",
        avatar: File(""),
        notifications: json['notifications'] ?? [],
        averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? [],
        ));
  }

  factory UserModel.fromJsonReserve(
      Map<String, dynamic> json, bool? reserveConfirmation) {
    return UserModel(
        id: json['id_google'] ?? "",
        email: json['email'] ?? "",
        role: json['role'] ?? 2,
        name: json['name'] ?? "",
        username: json['username'] ?? "",
        avatarId: json['avatar'] ?? "67c4bf09ae01906bd75ace8d",
        avatar: File(""),
        averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? []),
        reserveConfirmation: reserveConfirmation,
        notifications: json['notifications'] ?? []);
  }

  Map<String, dynamic> crateToJson(String password) {
    return {
      'id_google': id,
      'email': email,
      'role': role,
      'name': name,
      'username': username,
      'password': password,
      'notifications': notifications,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id_google': id,
      'email': email,
      'role': role,
      'name': name,
      'username': username,
      'notifications': notifications,
    };
  }

  UserEntity toUserEntity(dynamic avatarFile, bool? reserveConfirmation) {
    return UserEntity(
        id: id,
        email: email,
        role: role,
        name: name,
        username: username,
        avatar: avatarFile,
        averageRaiting: averageRaiting,
        reserveConfirmation: reserveConfirmation ?? false,
        notifications: notifications);
  }
}
