import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonCreateReserve extends StatelessWidget {
  const ButtonCreateReserve(
      {super.key,
      required GlobalKey<FormState> formKey,
      required TextEditingController freePlacesController,
      required TextEditingController hourStartController,
      required TextEditingController hourEndController,
      required TextEditingController descriptionController,
      required TextEditingController requiredMaterialController,
      required DifficultyEntity? selectedDifficulty,
      required GameCategoryEntity? selectedGameCategory,
      required GameEntity? selectedGame,
      required this.idShop,
      required this.idTable,
      required DateTime selectedDate,
      required this.searchDateTime,
      required this.reserveBloc})
      : _formKey = formKey,
        _freePlacesController = freePlacesController,
        _hourStartController = hourStartController,
        _hourEndController = hourEndController,
        _descriptionController = descriptionController,
        _requiredMaterialController = requiredMaterialController,
        _selectedDifficulty = selectedDifficulty,
        _selectedDate = selectedDate,
        _selectedGame = selectedGame;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _freePlacesController;
  final TextEditingController _hourStartController;
  final TextEditingController _hourEndController;
  final TextEditingController _descriptionController;
  final TextEditingController _requiredMaterialController;
  final DifficultyEntity? _selectedDifficulty;
  final GameEntity? _selectedGame;
  final DateTime _selectedDate;
  final int idTable;
  final int idShop;
  final ReserveBloc reserveBloc;
  final DateTime searchDateTime;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
          reserveBloc.add(CreateReserveEvent(
            reserve: ReserveEntity(
              id: 0,
              freePlaces: int.parse(_freePlacesController.text),
              dayDate: DateFormat('dd - MM - yyyy').format(_selectedDate),
              horaInicio: _hourStartController.text,
              horaFin: _hourEndController.text,
              description: _descriptionController.text,
              requiredMaterial: _requiredMaterialController.text,
              difficultyId: _selectedDifficulty!.id,
              gameId: _selectedGame!.id,
              gameName: _selectedGame.description,
              shopId: idShop,
              tableId: idTable,
              usersInTables: 0,
              isEvent: false,
            ),
            idUser:
                loginBloc.state.user!.role == 2 ? loginBloc.state.user!.id : '',
            dateReserve: _selectedDate,
            searchDateTime: searchDateTime
          ));

          context.go('/user/shop/$idShop/table/$idTable/');
        }
      },
      child: Text(AppLocalizations.of(context)!.save),
    );
  }
}
