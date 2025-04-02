import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterTables extends StatefulWidget {
  const FilterTables(
      {super.key,
      required this.currentShop,
      required this.reserveBloc,
      required this.tableBloc});
  final ShopEntity currentShop;
  final ReserveBloc reserveBloc;
  final TableBloc tableBloc;

  @override
  State<FilterTables> createState() => _FilterTablesState();
}

class _FilterTablesState extends State<FilterTables> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  /// Initializes the [_dateController], [_startTimeController], and
  /// [_endTimeController] with the values from [ReserveState.filterTables] if
  /// they are not null. This is done so that the values are set the first time
  /// the widget is built.
  ///
  /// This also calls [super.initState()] to complete the initialization of
  /// the [StatefulWidget].
  void initState() {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    if (reserveBloc.state.filterTables != null) {
      if (reserveBloc.state.filterTables!.containsKey('dateReserve')) {
      _dateController.text = reserveBloc.state.filterTables!['dateReserve']!;
      }
      if (reserveBloc.state.filterTables!.containsKey('startTime')) {
      _startTimeController.text = reserveBloc.state.filterTables!['startTime']!;
      }
      if (reserveBloc.state.filterTables!.containsKey('endTime')) {
      _endTimeController.text = reserveBloc.state.filterTables!['endTime']!;
      }
    }
    super.initState();
  }

  @override
  /// Builds the UI for the filter tables dialog.
  ///
  /// This widget is wrapped in a [BlocListener] to listen to the [ReserveBloc]
  /// events. When the reserves are loaded, it adds a [GetAvailableTablesEvent]
  /// to the [TableBloc] and pops the dialog. If there is an error, it shows a
  /// snack bar with the error message.
  ///
  /// The dialog contains a form with three [TextFormField]s for the date,
  /// start time, and end time. The date and times are read-only and can be
  /// selected using a date picker and a time picker. The form is validated
  /// before submitting.
  ///
  /// When the form is submitted, it adds a [GetReservesByShopEvent] to the
  /// [ReserveBloc] with the current shop, date, start time, and end time.
  ///
  /// The dialog is padded with 16 pixels of padding.
  Widget build(BuildContext context) {
    return BlocListener<ReserveBloc, ReserveState>(
      listener: (context, state) {
        if (state.reserves != null) {
          widget.tableBloc.add(GetAvailableTablesEvent(
              dayDate: _dateController.text,
              startTime: _startTimeController.text,
              endTime: _endTimeController.text,
              reserves: state.reserves!,
              shopId: widget.currentShop.id));
          Navigator.of(context).pop();
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.error_loading_reservations)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.date,
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  selectDate(context, _dateController);
                },
                validator: (value) => basicValidation(value, context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                onTap: () => selectTime(context, _startTimeController),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.start_time_hh_mm,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  String? error = validateHour(value, context);
                  if (error != null) {
                    return error;
                  }
                  if (_startTimeController.text
                          .compareTo(_endTimeController.text) >=
                      0) {
                    return AppLocalizations.of(context)!
                        .start_time_must_be_less_than_end_time;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                onTap: () => selectTime(context, _endTimeController),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.end_time_hh_mm,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  String? error = validateHour(value, context);
                  if (error != null) {
                    return error;
                  }
                  if (_startTimeController.text
                          .compareTo(_endTimeController.text) >=
                      0) {
                    return AppLocalizations.of(context)!
                        .end_time_must_be_greater_than_start_time;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.reserveBloc.add(GetReservesByShopEvent(
                      currentShop: widget.currentShop,
                      dateReserve: _dateController.text,
                      startTime: _startTimeController.text,
                      endTime: _endTimeController.text,
                    ));
                  }
                },
                child: Text(AppLocalizations.of(context)!.filter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
