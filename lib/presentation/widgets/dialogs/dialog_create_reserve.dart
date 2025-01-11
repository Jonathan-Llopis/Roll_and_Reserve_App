import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_reserve.dart';

class DialogCreateReserve extends StatefulWidget {
  final int idTable;
  final DateTime dateReserve;
  const DialogCreateReserve({
    required this.idTable,
    required this.dateReserve,
    super.key,
  });

  @override
  State<DialogCreateReserve> createState() => _ReserveFormDialogState();
}

class _ReserveFormDialogState extends State<DialogCreateReserve> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _freePlacesController = TextEditingController();
  final TextEditingController _hourStartController = TextEditingController();
  final TextEditingController _hourEndController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredMaterialController =
      TextEditingController();

  DifficultyEntity? _selectedDifficulty;
  GameCategoryEntity? _selectedGameCategory;
  GameEntity? _selectedGame;

  @override
  void dispose() {
    _freePlacesController.dispose();
    _hourStartController.dispose();
    _hourEndController.dispose();
    _descriptionController.dispose();
    _requiredMaterialController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    return AlertDialog(
      title: const Text("Crear Reserva"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    controller: _freePlacesController,
                    decoration: const InputDecoration(
                      labelText: "Plazas Totales en Mesa",
                      prefixIcon: Icon(Icons.people),
                    ),
                    keyboardType: TextInputType.number,
                    validator: basicValidationWithNumber),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _hourStartController,
                  decoration: const InputDecoration(
                    labelText: "Hora de inicio (HH:MM)",
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    String? error = validateHour(value);
                    if (error != null) {
                      return error;
                    }
                    if (isHourTaken(
                        reserveBloc.state.reserves!,
                        widget.dateReserve,
                        _hourStartController.text,
                        _hourEndController.text)) {
                      return 'La hora ya está cogida ese día';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _hourEndController,
                  decoration: const InputDecoration(
                    labelText: "Hora de fin (HH:MM)",
                    prefixIcon: Icon(Icons.access_time_filled),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    String? error = validateHour(value);
                    if (error != null) {
                      return error;
                    }
                    if (isHourTaken(
                        reserveBloc.state.reserves!,
                        widget.dateReserve,
                        _hourStartController.text,
                        _hourEndController.text)) {
                      return 'La hora ya está cogida ese día';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: basicValidation),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    controller: _requiredMaterialController,
                    decoration: const InputDecoration(
                      labelText: "Material necesario",
                      prefixIcon: Icon(Icons.build),
                    ),
                    validator: basicValidation),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<DifficultyEntity>(
                    decoration: const InputDecoration(
                      labelText: "Dificultad",
                    ),
                    value: _selectedDifficulty,
                    items: reserveBloc.state.difficulties!
                        .map((difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty.description),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDifficulty = newValue;
                      });
                    },
                    validator: validateSelectedValue),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<GameCategoryEntity>(
                    decoration: const InputDecoration(
                      labelText: "Categoría de juego",
                    ),
                    value: _selectedGameCategory,
                    items: reserveBloc.state.gameCategories!
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.description),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGameCategory = newValue;
                      });
                    },
                    validator: validateSelectedValue),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<GameEntity>(
                    decoration: const InputDecoration(
                      labelText: "Juego",
                    ),
                    value: _selectedGame,
                    items: reserveBloc.state.games!
                        .map((game) => DropdownMenuItem(
                              value: game,
                              child: Text(game.description),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGame = newValue;
                      });
                    },
                    validator: validateSelectedValue),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ButtonCreateReserve(
            formKey: _formKey,
            freePlacesController: _freePlacesController,
            hourStartController: _hourStartController,
            hourEndController: _hourEndController,
            descriptionController: _descriptionController,
            requiredMaterialController: _requiredMaterialController,
            selectedDifficulty: _selectedDifficulty,
            selectedGameCategory: _selectedGameCategory,
            selectedGame: _selectedGame,
            widget: widget,
            selectedDate: widget.dateReserve),
      ],
    );
  }
}
