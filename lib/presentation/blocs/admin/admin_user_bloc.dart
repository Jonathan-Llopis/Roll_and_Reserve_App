import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_users_info_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_event.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final GetAllUsersUseCase getAllUsersUseCase;

  AdminUserBloc({
    required this.getAllUsersUseCase,
  }) : super(const AdminUserInitial()) {
    on<GetAdminAllUsersEvent>(_onGetAllUsers);
  }

  Future<void> _onGetAllUsers(
    GetAdminAllUsersEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading(users: state.users));
    final result = await getAllUsersUseCase(NoParams());
    result.fold(
      (failure) => emit(
        AdminUserFailure(
          failure.message,
          users: state.users,
        ),
      ),
      (users) => emit(
        AdminUserLoaded(users: users),
      ),
    );
  }
}
