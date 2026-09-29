class UserEntity {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final dynamic avatar;
  final double averageRaiting;
  final bool? reserveConfirmation;
  final List<int> notifications;

  UserEntity({
    required this.email,
    required this.avatar,
    required this.averageRaiting,
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    this.reserveConfirmation,
    required this.notifications,
  });
}
