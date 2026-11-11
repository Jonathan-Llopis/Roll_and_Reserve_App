import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

sealed class AdminUserState extends Equatable {
  final List<UserEntity>? users;

  const AdminUserState({this.users});

  bool get isLoading => this is AdminUserLoading;
  String? get errorMessage =>
      this is AdminUserFailure ? (this as AdminUserFailure).message : null;

  AdminUserState copyWith({
    List<UserEntity>? users,
  });

  @override
  List<Object?> get props => [users];
}

class AdminUserInitial extends AdminUserState {
  const AdminUserInitial() : super();

  @override
  AdminUserState copyWith({
    List<UserEntity>? users,
  }) {
    return AdminUserLoaded(
      users: users ?? this.users ?? [],
    );
  }
}

class AdminUserLoading extends AdminUserState {
  const AdminUserLoading({super.users});

  @override
  AdminUserState copyWith({
    List<UserEntity>? users,
  }) {
    return AdminUserLoading(
      users: users ?? this.users,
    );
  }
}

class AdminUserLoaded extends AdminUserState {
  const AdminUserLoaded({required List<UserEntity> users})
      : super(users: users);

  @override
  AdminUserState copyWith({
    List<UserEntity>? users,
  }) {
    return AdminUserLoaded(
      users: users ?? this.users ?? [],
    );
  }
}

class AdminUserFailure extends AdminUserState {
  final String message;

  const AdminUserFailure(
    this.message, {
    super.users,
  });

  @override
  AdminUserState copyWith({
    List<UserEntity>? users,
  }) {
    return AdminUserFailure(
      message,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [...super.props, message];
}
