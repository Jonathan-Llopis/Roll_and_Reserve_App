import 'package:roll_and_reserve/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final dynamic avatar;
  final double averageRaiting;

  UserEntity(
      {required this.email,
      required this.avatar,
      required this.averageRaiting,
      required this.id,
      required this.name,
      required this.username,
      required this.role});

  UserModel toUserModel(String? avatarIdUpdate) {
    return UserModel(
        id: id,
        email: email,
        name: name,
        username: username,
        role: role,
        avatarId: avatarIdUpdate ?? "",
        avatar: avatar,
        averageRaiting: averageRaiting);
  }
}
