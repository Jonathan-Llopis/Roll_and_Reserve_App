import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';

void main() {
  group('LoginState', () {
    test('LoginFailure equality works correctly with spread super.props', () {
      const failure1 = LoginFailure('Invalid credentials', email: 'test@example.com');
      const failure2 = LoginFailure('Invalid credentials', email: 'test@example.com');
      const failure3 = LoginFailure('Other error', email: 'test@example.com');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });

    test('LoginSuccess copyWith retains existing properties when not overridden', () {
      const state = LoginSuccess(email: 'test@example.com', id: '123');
      final updated = state.copyWith(isEmailUsed: false);

      expect(updated.email, 'test@example.com');
      expect(updated.id, '123');
      expect(updated.isEmailUsed, false);
      expect(updated, isA<LoginSuccess>());
    });

    test('LoginLoading copyWith retains existing properties', () {
      const state = LoginLoading(email: 'test@example.com');
      final updated = state.copyWith(email: 'new@example.com');

      expect(updated.email, 'new@example.com');
      expect(updated, isA<LoginLoading>());
    });
  });
}
