import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GetAllGamesEvent extends GameEvent {
  const GetAllGamesEvent();
}

class GetAllCategoriesEvent extends GameEvent {
  const GetAllCategoriesEvent();
}

class GetAllDifficultiesEvent extends GameEvent {
  const GetAllDifficultiesEvent();
}

class SearchGameByNameEvent extends GameEvent {
  final String gameName;

  const SearchGameByNameEvent({required this.gameName});

  @override
  List<Object?> get props => [gameName];
}
