import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/add_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_last_ten_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_event.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetLastTenPlayersUseCase getLastTenPlayersUseCase;
  final AddUserToReserveUseCase addUserToReserveUseCase;
  final DeleteUserOfReserveUseCase deleteUserToReserveUseCase;

  PlayerBloc({
    required this.getLastTenPlayersUseCase,
    required this.addUserToReserveUseCase,
    required this.deleteUserToReserveUseCase,
  }) : super(const PlayerInitial()) {
    on<GetLastTenPlayersEvent>(_onGetLastTenPlayers);
    on<AddPlayerToReserveEvent>(_onAddPlayerToReserve);
    on<RemovePlayerFromReserveEvent>(_onRemovePlayerFromReserve);
  }

  Future<void> _onGetLastTenPlayers(
    GetLastTenPlayersEvent event,
    Emitter<PlayerState> emit,
  ) async {
    emit(
      PlayerLoading(
        lastUsers: state.lastUsers,
        operationSuccess: state.operationSuccess,
      ),
    );
    final result = await getLastTenPlayersUseCase(
      IdGoogleParams(googleId: event.idGoogle),
    );
    result.fold(
      (failure) => emit(
        PlayerFailure(
          failure.message,
          lastUsers: state.lastUsers,
          operationSuccess: state.operationSuccess,
        ),
      ),
      (users) => emit(
        PlayerLoaded(
          lastUsers: users,
          operationSuccess: state.operationSuccess,
        ),
      ),
    );
  }

  Future<void> _onAddPlayerToReserve(
    AddPlayerToReserveEvent event,
    Emitter<PlayerState> emit,
  ) async {
    emit(
      PlayerLoading(
        lastUsers: state.lastUsers,
        operationSuccess: state.operationSuccess,
      ),
    );
    final result = await addUserToReserveUseCase(
      UserToReserveUseCaseParams(
        idReserve: event.idReserve,
        idUser: event.idUser,
      ),
    );
    result.fold(
      (failure) => emit(
        PlayerFailure(
          failure.message,
          lastUsers: state.lastUsers,
          operationSuccess: state.operationSuccess,
        ),
      ),
      (success) => emit(
        PlayerLoaded(
          lastUsers: state.lastUsers,
          operationSuccess: success,
        ),
      ),
    );
  }

  Future<void> _onRemovePlayerFromReserve(
    RemovePlayerFromReserveEvent event,
    Emitter<PlayerState> emit,
  ) async {
    emit(
      PlayerLoading(
        lastUsers: state.lastUsers,
        operationSuccess: state.operationSuccess,
      ),
    );
    final result = await deleteUserToReserveUseCase(
      UserToReserveUseCaseParams(
        idReserve: event.idReserve,
        idUser: event.idUser,
      ),
    );
    result.fold(
      (failure) => emit(
        PlayerFailure(
          failure.message,
          lastUsers: state.lastUsers,
          operationSuccess: state.operationSuccess,
        ),
      ),
      (success) => emit(
        PlayerLoaded(
          lastUsers: state.lastUsers,
          operationSuccess: success,
        ),
      ),
    );
  }
}
