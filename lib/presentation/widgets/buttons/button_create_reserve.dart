import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_reserve.dart';
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
      required this.widget,
      required DateTime selectedDate})
      : _formKey = formKey,
        _freePlacesController = freePlacesController,
        _hourStartController = hourStartController,
        _hourEndController = hourEndController,
        _descriptionController = descriptionController,
        _requiredMaterialController = requiredMaterialController,
        _selectedDifficulty = selectedDifficulty,
        _selectedGameCategory = selectedGameCategory,
        _selectedDate = selectedDate,
        _selectedGame = selectedGame;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _freePlacesController;
  final TextEditingController _hourStartController;
  final TextEditingController _hourEndController;
  final TextEditingController _descriptionController;
  final TextEditingController _requiredMaterialController;
  final DifficultyEntity? _selectedDifficulty;
  final GameCategoryEntity? _selectedGameCategory;
  final GameEntity? _selectedGame;
  final DialogCreateReserve widget;
  final DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
          context.read<ReserveBloc>().add(CreateReserveEvent(
                reserve: ReserveEntity(
                  id: 0,
                  freePlaces: int.parse(_freePlacesController.text),
                  dayDate: DateFormat('dd - MM - yyyy').format(_selectedDate),
                  horaInicio: _hourStartController.text,
                  horaFin: _hourEndController.text,
                  description: _descriptionController.text,
                  requiredMaterial: _requiredMaterialController.text,
                  difficultyId: _selectedDifficulty!.id,
                  gameCategoryId: _selectedGameCategory!.id,
                  gameId: _selectedGame!.id,
                  tableId: widget.idTable,
                  usersReserve: [],
                ),
                idUser: loginBloc.state.user!.role == 2 ? loginBloc.state.user!.id : '',
                dateReserve: _selectedDate,
              ));

          Navigator.of(context).pop();
        }
      },
      child:  Text( AppLocalizations.of(context)!.save),
    );
  }
}
