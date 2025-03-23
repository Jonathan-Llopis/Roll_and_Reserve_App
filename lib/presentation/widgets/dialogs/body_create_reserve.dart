import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_reserve.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_fuild.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class BodyCreateReserve extends StatefulWidget {
  final int idTable;
  final int idShop;
  final ReserveBloc reserveBloc;
  final DateTime searchDateTime;
  final ReserveEntity? reserve;

  const BodyCreateReserve({
    required this.idTable,
    required this.reserveBloc,
    required this.idShop,
    required this.searchDateTime,
    this.reserve,
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
  void initState() {
    if (widget.reserve != null) {
      ReserveBloc reserveBloc = widget.reserveBloc;
      DifficultyEntity difficultyEntity = reserveBloc.state.difficulties!
          .firstWhere(
              (difficulty) => difficulty.id == widget.reserve!.difficultyId);
      GameEntity gameEntity = reserveBloc.state.games!
          .firstWhere((game) => game.id == widget.reserve!.gameId);

      _dayReservationController.text = widget.reserve!.dayDate;
      _freePlacesController.text = widget.reserve!.freePlaces.toString();
      _hourStartController.text = widget.reserve!.horaInicio;
      _hourEndController.text = widget.reserve!.horaFin;
      _descriptionController.text = widget.reserve!.description;
      _requiredMaterialController.text = widget.reserve!.requiredMaterial;
      _selectedDifficulty = difficultyEntity;
      _selectedGame = gameEntity;
    }
    super.initState();
  }

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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity * 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 20, 13, 2),
                child: SearchableDropdownFormField<GameEntity>.paginated(
                  backgroundDecoration: (Widget child) => InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      prefixIcon: Icon(Icons.gamepad,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8)),
                      labelText: AppLocalizations.of(context)!.game,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6)),
                    ),
                    child: child,
                  ),
                  paginatedRequest: (int page, String? searchKey) async {
                    final result = await widget.reserveBloc
                        .searchGamesUseCase(searchKey ?? 'all');
                    return result.fold(
                      (failure) => [],
                      (games) => games
                          .map((game) => SearchableDropdownMenuItem(
                                value: game,
                                label: game.description,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  leading: Icon(Icons.sports_esports,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  title: Text(game.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ))
                          .toList(),
                    );
                  },
                  validator: (value) =>
                      validateSelectedValue(value ?? _selectedGame, context),
                  onChanged: (GameEntity? value) {
                    setState(() {
                      _selectedGame = value;
                    });
                  },
                ),
              ),
            ),
            buildInputField(
                controller: _dayReservationController,
                label: AppLocalizations.of(context)!.reserve_day(''),
                icon: Icons.calendar_today,
                onTap: () async {
                  selectDate(context, _dayReservationController);
                },
                validator: (value) => basicValidation(value, context),
                context: context),
            buildInputField(
                controller: _freePlacesController,
                label: AppLocalizations.of(context)!.total_seats_at_table,
                icon: Icons.people,
                keyboardType: TextInputType.number,
                validator: (value) => basicValidationWithNumber(value, context),
                context: context),
            buildInputField(
                controller: _hourStartController,
                label: AppLocalizations.of(context)!.start_time_hh_mm,
                icon: Icons.access_time,
                onTap: () => selectTime(context, _hourStartController),
                validator: (value) => validateTime(
                    context,
                    value,
                    widget.reserveBloc,
                    _dayReservationController.text == ""
                        ? DateTime.now()
                        : widget.reserve == null
                            ? DateFormat("dd-MM-yyyy")
                                .parse(_dayReservationController.text)
                            : DateFormat("dd - MM - yyyy")
                                .parse(_dayReservationController.text),
                    _hourStartController,
                    _hourEndController,
                    widget.reserve == null
                        ? false
                        : _hourStartController.text
                                .compareTo(widget.reserve!.horaInicio) >=
                            0,
                    false),
                context: context),
            buildInputField(
                controller: _hourEndController,
                label: AppLocalizations.of(context)!.end_time_hh_mm,
                icon: Icons.access_time_filled,
                onTap: () => selectTime(context, _hourEndController),
                validator: (value) => validateTime(
                    context,
                    value,
                    widget.reserveBloc,
                    _dayReservationController.text == ""
                        ? DateTime.now()
                        : widget.reserve == null
                            ? DateFormat("dd-MM-yyyy")
                                .parse(_dayReservationController.text)
                            : DateFormat("dd - MM - yyyy")
                                .parse(_dayReservationController.text),
                    _hourEndController,
                    _hourStartController,
                    widget.reserve == null
                        ? false
                        : _hourEndController.text
                                .compareTo(widget.reserve!.horaFin) <=
                            0,
                    true),
                context: context),
            buildInputField(
                controller: _descriptionController,
                label: AppLocalizations.of(context)!.description,
                icon: Icons.description,
                keyboardType: TextInputType.text,
                validator: (value) => basicValidation(value, context),
                context: context),
            buildInputField(
              controller: _requiredMaterialController,
              label: AppLocalizations.of(context)!.required_material,
              icon: Icons.build,
              keyboardType: TextInputType.text,
              validator: (value) => null,
              context: context,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity * 0.8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                child: DropdownButtonFormField<DifficultyEntity>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    labelText: AppLocalizations.of(context)!.difficulty,
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
                  style: Theme.of(context).textTheme.bodyMedium,
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  value: _selectedDifficulty,
                  items: widget.reserveBloc.state.difficulties!
                      .map((difficulty) => DropdownMenuItem(
                            value: difficulty,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                difficulty.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() => _selectedDifficulty = newValue);
                  },
                  validator: (value) => validateSelectedValue(value, context),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: AppTheme.textButtonCancelStyle,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                  ),
                ),
                const SizedBox(width: 10.0),
                ButtonCreateReserve(
                  id: widget.reserve != null ? widget.reserve!.id : 0,
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
                      : widget.reserve == null
                          ? DateFormat("dd-MM-yyyy")
                              .parse(_dayReservationController.text)
                          : DateFormat("dd - MM - yyyy")
                              .parse(_dayReservationController.text),
                  reserveBloc: widget.reserveBloc,
                  searchDateTime: widget.searchDateTime,
                  update: widget.reserve != null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
