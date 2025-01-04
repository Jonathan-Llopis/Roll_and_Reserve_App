import 'package:firebase_auth/firebase_auth.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final String avatar;
  final double averageRaiting;

  UserModel(
      {required this.id,
      required this.email,
      required this.role,
      required this.name,
      required this.username,
      required this.avatar,
      required this.averageRaiting});

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
        id: userCredentials.user?.uid ?? "NO_ID",
        email: userCredentials.user?.email ?? "NO_EMAIL",
        name: userCredentials.user?.displayName ?? "NO_NAME",
        username: userCredentials.user?.displayName ?? "NO_NAME",
        role: 2,
        avatar: '',
        averageRaiting: 0);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id_user'],
        email: json['email'],
        role: json['role'],
        name: json['name'],
        username: json['username'],
        avatar: json['avatar'],
        averageRaiting: json['average_raiting']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'username': username,
    };
  }

  UserEntity toUserEntity() {
    return UserEntity(
        id: id,
        email: email,
        role: role,
        name: name,
        username: username,
        avatar: avatar,
        averageRaiting: averageRaiting);
  }
}
