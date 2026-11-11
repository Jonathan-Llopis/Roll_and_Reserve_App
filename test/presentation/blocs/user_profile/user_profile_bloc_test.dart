import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_user_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/validate_pass_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_event.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_state.dart';

class MockGetUserInfoUseCase extends Mock implements GetUserInfoUseCase {}

class MockUpdateUserInfoUseCase extends Mock implements UpdateUserInfoUseCase {}

class MockUpdatePasswordUsecase extends Mock implements UpdatePasswordUsecase {}

class MockValidatePasswordUsecase extends Mock
    implements ValidatePasswordUsecase {}

class MockIsEmailUsedUsecase extends Mock implements IsEmailUsedUsecase {}

class MockIsNameUsedUsecase extends Mock implements IsNameUsedUsecase {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockGetUserInfoUseCase mockGetUserInfoUseCase;
  late MockUpdateUserInfoUseCase mockUpdateUserInfoUseCase;
  late MockUpdatePasswordUsecase mockUpdatePasswordUsecase;
  late MockValidatePasswordUsecase mockValidatePasswordUsecase;
  late MockIsEmailUsedUsecase mockIsEmailUsedUsecase;
  late MockIsNameUsedUsecase mockIsNameUsedUsecase;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockGetUserInfoUseCase = MockGetUserInfoUseCase();
    mockUpdateUserInfoUseCase = MockUpdateUserInfoUseCase();
    mockUpdatePasswordUsecase = MockUpdatePasswordUsecase();
    mockValidatePasswordUsecase = MockValidatePasswordUsecase();
    mockIsEmailUsedUsecase = MockIsEmailUsedUsecase();
    mockIsNameUsedUsecase = MockIsNameUsedUsecase();
  });

  const testUser = UserEntity(
    id: 'user_123',
    name: 'John Doe',
    username: 'johndoe',
    email: 'john@example.com',
    avatar: 'avatar.png',
    role: 0,
    averageRaiting: 4.8,
    notifications: [],
  );

  UserProfileBloc buildBloc() {
    return UserProfileBloc(
      getUserInfoUseCase: mockGetUserInfoUseCase,
      updateUserInfoUseCase: mockUpdateUserInfoUseCase,
      updatePasswordUsecase: mockUpdatePasswordUsecase,
      validatePasswordUsecase: mockValidatePasswordUsecase,
      isEmailUsedUseCase: mockIsEmailUsedUsecase,
      isNameUsedUseCase: mockIsNameUsedUsecase,
    );
  }

  group('UserProfileBloc', () {
    test('initial state is UserProfileInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, const UserProfileInitial());
    });

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when FetchUserProfileEvent succeeds',
      build: () {
        when(() => mockGetUserInfoUseCase('user_123'))
            .thenAnswer((_) async => const Right(testUser));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const FetchUserProfileEvent(idGoogle: 'user_123')),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileLoaded(user: testUser),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileFailure] when FetchUserProfileEvent fails',
      build: () {
        when(() => mockGetUserInfoUseCase('user_123')).thenAnswer(
          (_) async => const Left(ServerFailure('User not found')),
        );
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const FetchUserProfileEvent(idGoogle: 'user_123')),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileFailure('User not found'),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when UpdateProfileInfoEvent succeeds',
      build: () {
        when(() => mockUpdateUserInfoUseCase(any()))
            .thenAnswer((_) async => const Right(true));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const UpdateProfileInfoEvent(user: testUser)),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileLoaded(user: testUser),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when UpdateUserPasswordEvent succeeds',
      build: () {
        when(() => mockUpdatePasswordUsecase('newPass', 'oldPass'))
            .thenAnswer((_) async => const Right(null));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const UpdateUserPasswordEvent(
          password: 'newPass',
          oldPassword: 'oldPass',
        ),
      ),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileLoaded(isPasswordUpdated: true),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when ValidateUserPasswordEvent succeeds',
      build: () {
        when(() => mockValidatePasswordUsecase('secret'))
            .thenAnswer((_) async => const Right(true));
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const ValidateUserPasswordEvent(password: 'secret')),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileLoaded(validatePassword: true),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when CheckEmailOrUsernameUsedEvent succeeds',
      build: () {
        when(() => mockIsEmailUsedUsecase('test@test.com'))
            .thenAnswer((_) async => const Right(false));
        when(() => mockIsNameUsedUsecase('testuser'))
            .thenAnswer((_) async => const Right(true));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const CheckEmailOrUsernameUsedEvent(
          email: 'test@test.com',
          name: 'testuser',
        ),
      ),
      expect: () => [
        const UserProfileLoading(),
        const UserProfileLoaded(
          isEmailUsed: false,
          isNameUsed: true,
        ),
      ],
    );
  });
}
