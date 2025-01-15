import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_reservation_text.dart';

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // Adjust width
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputReservationText(
                      controller: _freePlacesController,
                      label: "Plazas Totales en Mesa",
                      icon: Icons.people,
                      keyboardType: TextInputType.number,
                      validator: basicValidationWithNumber),
                  InputReservationText(
                      controller: _hourStartController,
                      label: "Hora de inicio (HH:MM)",
                      icon: Icons.access_time,
                      keyboardType: TextInputType.datetime,
                      validator: (value) => validateTime(
                          value,
                          reserveBloc,
                          widget.dateReserve,
                          _hourStartController,
                          _hourEndController)),
                  InputReservationText(
                      controller: _hourEndController,
                      label: "Hora de fin (HH:MM)",
                      icon: Icons.access_time_filled,
                      keyboardType: TextInputType.datetime,
                      validator: (value) => validateTime(
                          value,
                          reserveBloc,
                          widget.dateReserve,
                          _hourStartController,
                          _hourEndController)),
                  InputReservationText(
                      controller: _descriptionController,
                      label: "Descripción",
                      icon: Icons.description,
                      keyboardType: 
                       TextInputType.text,
                      validator: basicValidation),
                  InputReservationText(
                      controller: _requiredMaterialController,
                      label: "Material necesario",
                      icon: Icons.build,
                      keyboardType: TextInputType.text,
                      validator: basicValidation),
                 DropdownButtonFormField<DifficultyEntity>(
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
                  DropdownButtonFormField<GameCategoryEntity>(
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
                  DropdownButtonFormField<GameEntity>(
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
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar",
                      style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10.0),
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
                  selectedDate: widget.dateReserve,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
