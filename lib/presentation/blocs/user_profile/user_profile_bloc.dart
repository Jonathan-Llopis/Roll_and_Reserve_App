import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_user_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/validate_pass_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_event.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserInfoUseCase getUserInfoUseCase;
  final UpdateUserInfoUseCase updateUserInfoUseCase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  final ValidatePasswordUsecase validatePasswordUsecase;
  final IsEmailUsedUsecase isEmailUsedUseCase;
  final IsNameUsedUsecase isNameUsedUseCase;

  UserProfileBloc({
    required this.getUserInfoUseCase,
    required this.updateUserInfoUseCase,
    required this.updatePasswordUsecase,
    required this.validatePasswordUsecase,
    required this.isEmailUsedUseCase,
    required this.isNameUsedUseCase,
  }) : super(const UserProfileInitial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<UpdateProfileInfoEvent>(_onUpdateProfileInfo);
    on<UpdateUserPasswordEvent>(_onUpdateUserPassword);
    on<ValidateUserPasswordEvent>(_onValidateUserPassword);
    on<CheckEmailOrUsernameUsedEvent>(_onCheckEmailOrUsernameUsed);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      UserProfileLoading(
        user: state.user,
        isEmailUsed: state.isEmailUsed,
        isNameUsed: state.isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
    final result = await getUserInfoUseCase(event.idGoogle);
    result.fold(
      (failure) => emit(
        UserProfileFailure(
          failure.message,
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
      (user) => emit(
        UserProfileLoaded(
          user: user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
    );
  }

  Future<void> _onUpdateProfileInfo(
    UpdateProfileInfoEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      UserProfileLoading(
        user: state.user,
        isEmailUsed: state.isEmailUsed,
        isNameUsed: state.isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
    final result = await updateUserInfoUseCase(event.user);
    result.fold(
      (failure) => emit(
        UserProfileFailure(
          failure.message,
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
      (success) => emit(
        UserProfileLoaded(
          user: event.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
    );
  }

  Future<void> _onUpdateUserPassword(
    UpdateUserPasswordEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      UserProfileLoading(
        user: state.user,
        isEmailUsed: state.isEmailUsed,
        isNameUsed: state.isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
    final result = await updatePasswordUsecase(
      event.password,
      event.oldPassword,
    );
    result.fold(
      (failure) => emit(
        UserProfileFailure(
          failure.message,
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
      (_) => emit(
        UserProfileLoaded(
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          isPasswordUpdated: true,
        ),
      ),
    );
  }

  Future<void> _onValidateUserPassword(
    ValidateUserPasswordEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      UserProfileLoading(
        user: state.user,
        isEmailUsed: state.isEmailUsed,
        isNameUsed: state.isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
    final result = await validatePasswordUsecase(event.password);
    result.fold(
      (failure) => emit(
        UserProfileFailure(
          failure.message,
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
        ),
      ),
      (valid) => emit(
        UserProfileLoaded(
          user: state.user,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: valid,
        ),
      ),
    );
  }

  Future<void> _onCheckEmailOrUsernameUsed(
    CheckEmailOrUsernameUsedEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(
      UserProfileLoading(
        user: state.user,
        isEmailUsed: state.isEmailUsed,
        isNameUsed: state.isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
    final emailResult = await isEmailUsedUseCase(event.email);
    final nameResult = await isNameUsedUseCase(event.name);

    final isEmailUsed = emailResult.fold((_) => false, (used) => used);
    final isNameUsed = nameResult.fold((_) => false, (used) => used);

    emit(
      UserProfileLoaded(
        user: state.user,
        isEmailUsed: isEmailUsed,
        isNameUsed: isNameUsed,
        validatePassword: state.validatePassword,
      ),
    );
  }
}
