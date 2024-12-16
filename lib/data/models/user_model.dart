import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name});

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
        id: userCredentials.user?.uid ?? "NO_ID",
        email: userCredentials.user?.email ?? "NO_EMAIL",
        name: userCredentials.user?.displayName ?? "NO_NAME");
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
