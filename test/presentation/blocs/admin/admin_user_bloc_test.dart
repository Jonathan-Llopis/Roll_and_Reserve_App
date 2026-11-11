import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_users_info_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_event.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_state.dart';

class MockGetAllUsersUseCase extends Mock implements GetAllUsersUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetAllUsersUseCase mockGetAllUsersUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetAllUsersUseCase = MockGetAllUsersUseCase();
  });

  final testUsers = [
    UserEntity(
      id: 'admin_1',
      name: 'Admin User',
      username: 'admin',
      email: 'admin@example.com',
      avatar: 'avatar.png',
      role: 1,
      averageRaiting: 5.0,
      notifications: [],
    ),
    UserEntity(
      id: 'user_2',
      name: 'Regular User',
      username: 'regular',
      email: 'user@example.com',
      avatar: 'avatar2.png',
      role: 0,
      averageRaiting: 4.0,
      notifications: [],
    ),
  ];

  group('AdminUserBloc', () {
    test('initial state is AdminUserInitial', () {
      final bloc = AdminUserBloc(getAllUsersUseCase: mockGetAllUsersUseCase);
      expect(bloc.state, const AdminUserInitial());
    });

    blocTest<AdminUserBloc, AdminUserState>(
      'emits [AdminUserLoading, AdminUserLoaded] when GetAdminAllUsersEvent succeeds',
      build: () {
        when(() => mockGetAllUsersUseCase(any()))
            .thenAnswer((_) async => Right(testUsers));
        return AdminUserBloc(getAllUsersUseCase: mockGetAllUsersUseCase);
      },
      act: (bloc) => bloc.add(const GetAdminAllUsersEvent()),
      expect: () => [
        const AdminUserLoading(),
        AdminUserLoaded(users: testUsers),
      ],
    );

    blocTest<AdminUserBloc, AdminUserState>(
      'emits [AdminUserLoading, AdminUserFailure] when GetAdminAllUsersEvent fails',
      build: () {
        when(() => mockGetAllUsersUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Permission denied')),
        );
        return AdminUserBloc(getAllUsersUseCase: mockGetAllUsersUseCase);
      },
      act: (bloc) => bloc.add(const GetAdminAllUsersEvent()),
      expect: () => [
        const AdminUserLoading(),
        const AdminUserFailure('Permission denied'),
      ],
    );
  });
}
