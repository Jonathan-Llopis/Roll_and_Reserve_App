import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/input_field.dart';
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
  /// Disposes of the [TextEditingController]s used in the form.
  //
  /// This is necessary to prevent memory leaks when the widget is removed from
  /// the tree.
  void dispose() {
    _freePlacesController.dispose();
    _descriptionController.dispose();
    _requiredMaterialController.dispose();
    super.dispose();
  }

  @override
/// Initializes the state of the widget.
///
/// This method sends a [GetAvailableTablesEvent] to the [TableBloc] to fetch
/// the tables available for reservation. It uses the start and end time of the
/// event, the date, and the list of existing reserves to filter the available
/// tables for the given shop.

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
  /// Builds the form to create a new event.
  ///
  /// The form is inside a [SingleChildScrollView] and contains a [Form] with
  /// the following fields:
  ///
  /// - a [SearchableDropdownFormField] to select the game,
  /// - a [TextField] to enter the number of seats available at the table,
  /// - a [TextField] to enter the description of the event,
  /// - a [TextField] to enter the required material,
  /// - a [DropdownButtonFormField] to select the difficulty of the event,
  /// - a [TableSelectionCheckbox] to select the tables where the event will be
  ///   held,
  /// - two buttons, one to cancel and one to create the event.
  ///
  /// The [Form] is validated when the create button is pressed.
  ///
  /// If the form is valid, the [ButtonCreateEvent] is enabled and the user can
  /// create the event. The [ButtonCreateEvent] sends a [CreateEventsEvent] to
  /// the [ReserveBloc] with the selected tables, the start and end time of the
  /// event, the description of the event, the required material, the
  /// difficulty of the event, and the game.
  ///
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(13, 20, 13, 2),
                        child:
                            SearchableDropdownFormField<GameEntity>.paginated(
                          backgroundDecoration: (Widget child) =>
                              InputDecorator(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                          paginatedRequest:
                              (int page, String? searchKey) async {
                            final result = await widget.reserveBloc
                                .searchGamesUseCase(searchKey ?? 'all');
                            return result.fold(
                              (failure) => [],
                              (games) => games
                                  .map((game) => SearchableDropdownMenuItem(
                                        value: game,
                                        label: game.description,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
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
                          validator: (value) => validateSelectedValue(
                              value ?? _selectedGame, context),
                          onChanged: (GameEntity? value) {
                            setState(() {
                              _selectedGame = value;
                            });
                          },
                        ),
                      ),
                    ),
                    buildInputField(
                        controller: _freePlacesController,
                        label:
                            AppLocalizations.of(context)!.total_seats_at_table,
                        icon: Icons.people,
                        keyboardType: TextInputType.number,
                        context: context,
                        validator: (value) =>
                            basicValidationWithNumber(value, context)),
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
                        validator: (value) => basicValidation(value, context),
                        context: context),
                    SizedBox(
                      width: double.infinity * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 20),
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
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                ),
                          ),
                          dropdownColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          style: Theme.of(context).textTheme.bodyMedium,
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          value: _selectedDifficulty,
                          items: widget.reserveBloc.state.difficulties!
                              .map((difficulty) => DropdownMenuItem(
                                    value: difficulty,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        difficulty.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() => _selectedDifficulty = newValue);
                          },
                          validator: (value) =>
                              validateSelectedValue(value, context),
                        ),
                      ),
                    ),
                     const SizedBox(height: 20.0),
                      TableSelectionCheckbox(
                        tables: state.tablesFromShop!,
                        onSelectionChanged: (selectedTableIds) {
                          setState(() {
                            _selectedTableIds = selectedTableIds;
                          });
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
