import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

const tUserEntity = UserEntity(
  id: 'user_123',
  email: 'test@rollandreserve.com',
  name: 'Test User',
  username: 'tester',
  role: 2,
  avatar: 'assets/images/default_avatar.png',
  averageRaiting: 4.5,
  notifications: [1, 2],
);

final tUserModel = UserModel(
  id: 'user_123',
  email: 'test@rollandreserve.com',
  name: 'Test User',
  username: 'tester',
  role: 2,
  avatarId: 'avatar_id_abc',
  avatar: 'assets/images/default_avatar.png',
  averageRaiting: 4.5,
  notifications: const [1, 2],
);

final tUserJson = {
  'id_google': 'user_123',
  'email': 'test@rollandreserve.com',
  'name': 'Test User',
  'user_name': 'tester',
  'role': 2,
  'avatar': 'assets/images/default_avatar.png',
  'average_rating': 4.5,
  'notification': [1, 2],
};
