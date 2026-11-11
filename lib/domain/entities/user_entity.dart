import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final dynamic avatar;
  final double averageRaiting;
  double get averageRating => averageRaiting;
  final bool? reserveConfirmation;
  final List<int> notifications;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.username,
    required this.avatar,
    required this.averageRaiting,
    this.reserveConfirmation,
    required this.notifications,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    int? role,
    String? name,
    String? username,
    dynamic avatar,
    double? averageRaiting,
    bool? reserveConfirmation,
    List<int>? notifications,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      averageRaiting: averageRaiting ?? this.averageRaiting,
      reserveConfirmation: reserveConfirmation ?? this.reserveConfirmation,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        role,
        name,
        username,
        avatar,
        averageRaiting,
        reserveConfirmation,
        notifications,
      ];
}
