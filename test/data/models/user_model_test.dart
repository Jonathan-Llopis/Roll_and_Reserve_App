import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

void main() {
  final tJson = <String, dynamic>{
    'id_google': 'user_123',
    'email': 'test@rollandreserve.com',
    'role': 2,
    'name': 'Test User',
    'username': 'tester',
    'avatar': 'avatar_id_abc',
    'notifications': <int>[1, 2],
    'average_raiting': 4.5,
  };

  group('UserModel', () {
    test('fromJson should return a valid UserModel when JSON is complete', () {
      final model = UserModel.fromJson(tJson);

      expect(model.id, 'user_123');
      expect(model.email, 'test@rollandreserve.com');
      expect(model.role, 2);
      expect(model.name, 'Test User');
      expect(model.username, 'tester');
      expect(model.avatarId, 'avatar_id_abc');
      expect(model.averageRaiting, 4.5);
    });

    test('fromJson should handle empty or null fields with defaults', () {
      final emptyJson = <String, dynamic>{};
      final model = UserModel.fromJson(emptyJson);

      expect(model.id, '');
      expect(model.email, '');
      expect(model.role, 2);
      expect(model.averageRaiting, 0.0);
    });

    test('toUserEntity should return a corresponding UserEntity', () {
      final model = UserModel.fromJson(tJson);
      final entity = model.toUserEntity('avatar.png', true);

      expect(entity, isA<UserEntity>());
      expect(entity.id, model.id);
      expect(entity.email, model.email);
      expect(entity.role, model.role);
      expect(entity.reserveConfirmation, true);
    });

    test('toJson should return correct map structure', () {
      final model = UserModel.fromJson(tJson);
      final json = model.toJson();

      expect(json['id_google'], 'user_123');
      expect(json['email'], 'test@rollandreserve.com');
      expect(json['role'], 2);
    });
  });
}
