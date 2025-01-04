class UserEntity {
  final String id;
  final String email;
  final int role;
  final String name;
  final String username;
  final String avatar;
  final double averageRaiting;

  UserEntity(
      {required this.email,
      required this.avatar,
      required this.averageRaiting,
      required this.id,
      required this.name,
      required this.username,
      required this.role});
}
