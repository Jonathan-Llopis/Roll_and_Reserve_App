import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';

void main() {
  group('ReserveState', () {
    test('ReserveFailure equality works correctly with spread super.props', () {
      const failure1 = ReserveFailure('Something went wrong', idReserve: 10);
      const failure2 = ReserveFailure('Something went wrong', idReserve: 10);
      const failure3 = ReserveFailure('Other error', idReserve: 10);

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
    });

    test('ReserveSuccess copyWith retains existing properties when not overridden', () {
      const state = ReserveSuccess(idReserve: 5);
      final updated = state.copyWith(filterTables: {'shop': '1'});

      expect(updated.idReserve, 5);
      expect(updated.filterTables, {'shop': '1'});
      expect(updated, isA<ReserveSuccess>());
    });

    test('ReserveLoading copyWith retains existing properties', () {
      const state = ReserveLoading(idReserve: 5);
      final updated = state.copyWith(idReserve: 6);

      expect(updated.idReserve, 6);
      expect(updated, isA<ReserveLoading>());
    });
  });
}
