import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_reserve.dart';

class ReserveFormDialog extends StatefulWidget {
  final int idTable;
  const ReserveFormDialog({
    required this.idTable,
    super.key,
  });

  @override
  State<ReserveFormDialog> createState() => _ReserveFormDialogState();
}

class _ReserveFormDialogState extends State<ReserveFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  final TextEditingController _freePlacesController = TextEditingController();
  final TextEditingController _hourStartController = TextEditingController();
  final TextEditingController _hourEndController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredMaterialController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Opciones seleccionadas
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
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        _dateController.text = formatter.format(picked);
      });
    }
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
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Fecha de reserva",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _freePlacesController,
                  decoration: const InputDecoration(
                    labelText: "Plazas Totales en Mesa",
                    prefixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
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
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
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
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _requiredMaterialController,
                  decoration: const InputDecoration(
                    labelText: "Material necesario",
                    prefixIcon: Icon(Icons.build),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
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
                  validator: (value) {
                    if (value == null) {
                      return "Selecciona una opción";
                    }
                    return null;
                  },
                ),
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
                  validator: (value) {
                    if (value == null) {
                      return "Selecciona una opción";
                    }
                    return null;
                  },
                ),
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
                  validator: (value) {
                    if (value == null) {
                      return "Selecciona una opción";
                    }
                    return null;
                  },
                ),
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
        CreateReserveButton(formKey: _formKey, freePlacesController: _freePlacesController, dateController: _dateController, hourStartController: _hourStartController, hourEndController: _hourEndController, descriptionController: _descriptionController, requiredMaterialController: _requiredMaterialController, selectedDifficulty: _selectedDifficulty, selectedGameCategory: _selectedGameCategory, selectedGame: _selectedGame, widget: widget),
      ],
    );
  }
}
