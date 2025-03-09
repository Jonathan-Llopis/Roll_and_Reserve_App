import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/body_create_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonCreateEvent extends StatelessWidget {
  const ButtonCreateEvent({
    super.key,
    required GlobalKey<FormState> formKey,
    required List<int> selectedTableIds,
    required TextEditingController freePlacesController,
    required this.widget,
    required TextEditingController descriptionController,
    required TextEditingController requiredMaterialController,
    required DifficultyEntity? selectedDifficulty,
    required GameEntity? selectedGame,
  })  : _formKey = formKey,
        _selectedTableIds = selectedTableIds,
        _freePlacesController = freePlacesController,
        _descriptionController = descriptionController,
        _requiredMaterialController = requiredMaterialController,
        _selectedDifficulty = selectedDifficulty,

        _selectedGame = selectedGame;

  final GlobalKey<FormState> _formKey;
  final List<int> _selectedTableIds;
  final TextEditingController _freePlacesController;
  final BodyCreateEvent widget;
  final TextEditingController _descriptionController;
  final TextEditingController _requiredMaterialController;
  final DifficultyEntity? _selectedDifficulty;
  final GameEntity? _selectedGame;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          List<ReserveEntity> reserves = [];
          for (int table in _selectedTableIds) {
            reserves.add(ReserveEntity(
              id: 0,
              freePlaces: int.parse(_freePlacesController.text),
              dayDate: DateFormat('dd - MM - yyyy').format(widget.starteTime),
              horaInicio: DateFormat('HH:mm').format(widget.starteTime),
              horaFin: DateFormat('HH:mm').format(widget.endTime),
              description: _descriptionController.text,
              requiredMaterial: _requiredMaterialController.text,
              difficultyId: _selectedDifficulty!.id,
              gameId: _selectedGame!.id,
              gameName: _selectedGame.description,
              tableId: table,
              usersInTables: 0,
              isEvent: true,
              shopId: widget.idShop,
            ));
          }
          widget.reserveBloc.add(CreateEventsEvent(reserves: reserves));
        }
        context.go('/user/events/${widget.idShop}');
      },
      child: Text(AppLocalizations.of(context)!.save),
    );
  }
}
