import 'package:equatable/equatable.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object?> get props => [];
}

class GetAdminAllUsersEvent extends AdminUserEvent {
  const GetAdminAllUsersEvent();
}
