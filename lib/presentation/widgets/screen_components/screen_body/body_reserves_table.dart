import 'package:flutter/material.dart';
import 'package:roll_and_reserve/config/router/routes.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';

class BodyReservesTable extends StatefulWidget {
  final TableEntity table;
  final DateTime selectedDate;
  final int idShop;
  const BodyReservesTable(
      {super.key,
      required this.table,
      required this.selectedDate,
      required this.idShop});

  @override
  State<BodyReservesTable> createState() => _BodyReservesTableState();
}

class _BodyReservesTableState extends State<BodyReservesTable> {
  
  DateTime? selectedDate;
  @override
  /// Builds the body of the screen for a specific table and date.
  ///
  /// The top row shows the table number and a button to filter the reserves
  /// by date. The middle row shows the selected date and two buttons to
  /// navigate to the previous and next day. The bottom row shows the reserves
  /// for the selected date and table.
  ///
  /// The reserves are shown in a list view and each reserve is shown in a
  /// [CardReserve].
  ///
  /// The date is shown in the format "dd-mm-yyyy" and the reserves are sorted
  /// by start time.
  Widget build(BuildContext context) {
    selectedDate ??= widget.selectedDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .table_number(widget.table.numberTable),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.available_reservations,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.book_online, size: 48, color: Colors.green),
                  ElevatedButton(
                    onPressed: () async {
                      LanguageBloc languageBloc =
                          BlocProvider.of<LanguageBloc>(context);
                      final DateTime? picked = await showDatePicker(
                        locale: languageBloc.state.locale,
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                        // ignore: use_build_context_synchronously
                        context.read<ReserveBloc>().add(
                              GetReserveByDateEvent(
                                  dateReserve: selectedDate!,
                                  idTable: widget.table.id),
                            );
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.filter_by_date),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedDate =
                        selectedDate!.subtract(const Duration(days: 1));
                  });
                  context.read<ReserveBloc>().add(
                        GetReserveByDateEvent(
                            dateReserve: selectedDate!,
                            idTable: widget.table.id),
                      );
                },
                child: const Icon(Icons.arrow_back)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .available_reservations_for_date(""),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getDate(selectedDate.toString()),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedDate = selectedDate!.add(const Duration(days: 1));
                  });
                  context.read<ReserveBloc>().add(
                        GetReserveByDateEvent(
                            dateReserve: selectedDate!,
                            idTable: widget.table.id),
                      );
                },
                child: const Icon(Icons.arrow_forward)),
          ],
        ),
        BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
          return buildContent<ReserveState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.reserves != null,
            context: context,
            contentBuilder: (state) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                    itemCount: state.reserves?.length,
                    itemBuilder: (context, index) {
                      final reserve = state.reserves![index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        ScreenReserve(
                                  idReserve: reserve.id,
                                  idShop: reserve.shopId,
                                  idTable: reserve.tableId,
                                  appBar: appBar,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: CardReserve(
                            reserve: reserve,
                            idShop: widget.idShop,
                          ));
                    },
                  ),
                ),
              );
            },
          );
        })
      ],
    );
  }
}
