import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_reservation_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class BodyCreateReserve extends StatefulWidget {
  final int idTable;
  final int idShop;
  final ReserveBloc reserveBloc;
  final DateTime searchDateTime;

  const BodyCreateReserve({
    required this.idTable,
    required this.reserveBloc,
    required this.idShop,
    required this.searchDateTime,
    super.key,
  });

  @override
  State<BodyCreateReserve> createState() => _BodyCreateReserveState();
}

class _BodyCreateReserveState extends State<BodyCreateReserve> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _freePlacesController = TextEditingController();
  final TextEditingController _dayReservationController =
      TextEditingController();
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
    _dayReservationController.dispose();
    _freePlacesController.dispose();
    _hourStartController.dispose();
    _hourEndController.dispose();
    _descriptionController.dispose();
    _requiredMaterialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SearchableDropdownFormField<GameEntity>.paginated(
                backgroundDecoration: (Widget child) => Container(
                    decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.0,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: child,
                ),
                hintText: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(AppLocalizations.of(context)!.game, style: TextStyle(fontSize: 16.0)),
                ),
                margin: const EdgeInsets.all(0),
                paginatedRequest: (int page, String? searchKey) async {
                  final result = await widget.reserveBloc
                      .searchGamesUseCase(searchKey ?? 'all');
                  return result.fold(
                    (failure) => [],
                    (games) => games
                        .map((game) => SearchableDropdownMenuItem(
                              value: game,
                              label: game.description,
                              child: Padding(
                                 padding: const EdgeInsets.all(16.0),
                                child: Text(game.description),
                              ),
                            ))
                        .toList(),
                  );
                },
                validator: (value) => validateSelectedValue(value, context),
                onChanged: (GameEntity? value) {
                  setState(() {
                    _selectedGame = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              InputReservationText(
                controller: _dayReservationController,
                label: AppLocalizations.of(context)!.reserve_day(''),
                icon: Icons.calendar_today,
                onTap: () async {
                  selectDate(context, _dayReservationController);
                },
                readOnly: true,
                validator: (value) => basicValidation(value, context),
              ),
              InputReservationText(
                controller: _freePlacesController,
                label: AppLocalizations.of(context)!.total_seats_at_table,
                icon: Icons.people,
                keyboardType: TextInputType.number,
                validator: (value) => basicValidationWithNumber(value, context),
              ),
              InputReservationText(
                controller: _hourStartController,
                label: AppLocalizations.of(context)!.start_time_hh_mm,
                icon: Icons.access_time,
                onTap: () => selectTime(context, _hourStartController),
                readOnly: true,
                validator: (value) => validateTime(
                  context,
                  value,
                  widget.reserveBloc,
                  _dayReservationController.text == ""
                      ? DateTime.now()
                      : DateFormat('dd-MM-yyyy')
                          .parse(_dayReservationController.text),
                  _hourStartController,
                  _hourEndController,
                ),
              ),
              InputReservationText(
                controller: _hourEndController,
                label: AppLocalizations.of(context)!.end_time_hh_mm,
                icon: Icons.access_time_filled,
                onTap: () => selectTime(context, _hourEndController),
                readOnly: true,
                validator: (value) => validateTime(
                  context,
                  value,
                  widget.reserveBloc,
                  _dayReservationController.text == ""
                      ? DateTime.now()
                      : DateFormat('dd-MM-yyyy')
                          .parse(_dayReservationController.text),
                  _hourStartController,
                  _hourEndController,
                ),
              ),
              InputReservationText(
                controller: _descriptionController,
                label: AppLocalizations.of(context)!.description,
                icon: Icons.description,
                keyboardType: TextInputType.text,
                validator: (value) => basicValidation(value, context),
              ),
              InputReservationText(
                controller: _requiredMaterialController,
                label: AppLocalizations.of(context)!.required_material,
                icon: Icons.build,
                keyboardType: TextInputType.text,
                validator: (value) => null,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<DifficultyEntity>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.difficulty,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedDifficulty,
                items: widget.reserveBloc.state.difficulties!
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
                validator: (value) => validateSelectedValue(value, context),
              ),
              const SizedBox(height: 16.0),         
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(color: Colors.red),
                    ),
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
                    idTable: widget.idTable,
                    idShop: widget.idShop,
                    selectedDate: _dayReservationController.text == ""
                        ? DateTime.now()
                        : DateFormat('dd-MM-yyyy')
                            .parse(_dayReservationController.text),
                    reserveBloc: widget.reserveBloc,
                    searchDateTime: widget.searchDateTime,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
