import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_create_event.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_reservation_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/table_selection_checkbox.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class BodyCreateEvent extends StatefulWidget {
  final int idShop;
  final ReserveBloc reserveBloc;
  final List<ReserveEntity> reserves;
  final DateTime starteTime;
  final DateTime endTime;

  const BodyCreateEvent({
    required this.reserveBloc,
    required this.reserves,
    required this.idShop,
    required this.starteTime,
    required this.endTime,
    super.key,
  });

  @override
  State<BodyCreateEvent> createState() => _BodyCreateEventState();
}

class _BodyCreateEventState extends State<BodyCreateEvent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _freePlacesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredMaterialController =
      TextEditingController();

  DifficultyEntity? _selectedDifficulty;
  GameEntity? _selectedGame;
  List<int> _selectedTableIds = [];

  @override
  void dispose() {
    _freePlacesController.dispose();
    _descriptionController.dispose();
    _requiredMaterialController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<TableBloc>().add(GetAvailableTablesEvent(
        dayDate: DateFormat('dd-MM-yyyy').format(widget.starteTime),
        startTime: DateFormat('HH:mm').format(widget.starteTime),
        reserves: widget.reserves,
        endTime: DateFormat('HH:mm').format(widget.endTime),
        shopId: widget.idShop));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        return buildContent<TableState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.tablesFromShop != null,
          context: context,
          contentBuilder: (state) {
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
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
                          child: Text(AppLocalizations.of(context)!.game,
                              style: TextStyle(fontSize: 16.0)),
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
                        validator: (value) =>
                            validateSelectedValue(value, context),
                        onChanged: (GameEntity? value) {
                          setState(() {
                            _selectedGame = value;
                          });
                        },
                      ),
                      InputReservationText(
                          controller: _freePlacesController,
                          label: AppLocalizations.of(context)!
                              .total_seats_at_table,
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              basicValidationWithNumber(value, context)),
                      InputReservationText(
                          controller: _descriptionController,
                          label: AppLocalizations.of(context)!.description,
                          icon: Icons.description,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              basicValidation(value, context)),
                      InputReservationText(
                          controller: _requiredMaterialController,
                          label:
                              AppLocalizations.of(context)!.required_material,
                          icon: Icons.build,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              basicValidation(value, context)),
                      DropdownButtonFormField<DifficultyEntity>(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.difficulty,
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
                          validator: (value) =>
                              validateSelectedValue(value, context)),
                      const SizedBox(height: 20.0),
                      TableSelectionCheckbox(
                        tables: state.tablesFromShop!,
                        onSelectionChanged: (selectedTableIds) {
                          setState(() {
                            _selectedTableIds = selectedTableIds;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.cancel,
                                style: TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 10.0),
                          ButtonCreateEvent(
                              formKey: _formKey,
                              selectedTableIds: _selectedTableIds,
                              freePlacesController: _freePlacesController,
                              widget: widget,
                              descriptionController: _descriptionController,
                              requiredMaterialController:
                                  _requiredMaterialController,
                              selectedDifficulty: _selectedDifficulty,
                              selectedGame: _selectedGame)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
