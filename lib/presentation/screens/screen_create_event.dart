import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/body_create_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

class ScreenCreateEvent extends StatefulWidget {
  const ScreenCreateEvent({super.key, required this.idShop});
  final int idShop;

  @override
  State<ScreenCreateEvent> createState() => _ScreenCreateEventState();
}

class _ScreenCreateEventState extends State<ScreenCreateEvent> {
  Map<String, DateTime>? _selectedDates;

  Future<void> _selectDateAndTime() async {
    try {
      DateTime? startDate = await showDatePicker(
        helpText: "Selecciona la fecha de inicio del evento",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (startDate == null) {
        throw Exception("Fecha inicial no seleccionada");
      }

      TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (startTime == null) {
        throw Exception("Hora inicial no seleccionada");
      }

      DateTime? endDate = await showDatePicker(
        helpText: "Selecciona la fecha de fin del evento",
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(2101),
      );

      if (endDate == null) {
        throw Exception("Fecha final no seleccionada");
      }

      if (endDate.isBefore(startDate)) {
        throw Exception(
            "La fecha final no puede ser anterior a la fecha inicial");
      }

      if (endDate.difference(startDate).inDays == -1) {
        throw Exception("El evento debe ser en el mismo dia");
      }

      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: startTime,
      );

      if (endTime == null) {
        throw Exception("Hora final no seleccionada");
      }

      if (endDate.isAtSameMomentAs(startDate) && 
          DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute)
          .isBefore(DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute))) {
        throw Exception(
            "La fecha final no puede ser anterior a la fecha inicial");
      }

      if (endTime.hour < startTime.hour) {
        throw Exception(
            "La fecha final no puede ser anterior a la fecha inicial");
      }

      if (endTime.hour == startTime.hour && endTime.minute < startTime.minute) {
        throw Exception(
            "La fecha final no puede ser anterior a la fecha inicial");
      }

      setState(() {
        _selectedDates = {
          "startDateTime": DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
            startTime.hour,
            startTime.minute,
          ),
          "endDateTime": DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            endTime.hour,
            endTime.minute,
          ),
        };
      });
    } catch (e) {
      errorDatePicker(context, e.toString(), widget.idShop);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectDateAndTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDates == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final startDateTime = _selectedDates!['startDateTime']!;
    final endDateTime = _selectedDates!['endDateTime']!;

    context.read<ReserveBloc>().add(GetReservesEvent());
    ReserveBloc reserveBloc = context.read<ReserveBloc>();

    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.reserves != null,
          contentBuilder: (state) {
            return DefaultScaffold(
              body: BodyCreateEvent(
                reserveBloc: reserveBloc,
                reserves: state.reserves!,
                idShop: widget.idShop,
                starteTime: startDateTime,
                endTime: endDateTime,
              ),
            );
          },
        );
      },
    );
  }
}
