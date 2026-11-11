import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/datasources/reserve_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/reserve_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockReserveRemoteDataSource extends Mock
    implements ReserveRemoteDataSource {}

class MockUserDatasource extends Mock implements UserDatasource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ReserveRepositoryImpl repository;
  late MockReserveRemoteDataSource mockRemoteDataSource;
  late MockUserDatasource mockUserDatasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockRemoteDataSource = MockReserveRemoteDataSource();
    mockUserDatasource = MockUserDatasource();
    mockSharedPreferences = MockSharedPreferences();

    repository = ReserveRepositoryImpl(
      mockRemoteDataSource,
      mockSharedPreferences,
      mockUserDatasource,
    );
  });

  group('ReserveRepositoryImpl - Token Safety', () {
    test('getAllReserves returns AuthFailure when token is null', () async {
      when(() => mockSharedPreferences.getString('token')).thenReturn(null);

      final result = await repository.getAllReserves();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should not succeed'),
      );
    });

    test('deleteReserve returns AuthFailure when token is null', () async {
      when(() => mockSharedPreferences.getString('token')).thenReturn(null);

      final result = await repository.deleteReserve(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should not succeed'),
      );
    });

    test('getEvents returns AuthFailure when token is null', () async {
      when(() => mockSharedPreferences.getString('token')).thenReturn(null);

      final result = await repository.getEvents(10);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should not succeed'),
      );
    });
  });
}
