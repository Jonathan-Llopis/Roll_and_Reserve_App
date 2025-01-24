import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserves_table.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';

  DateTime? selectedDate;

class BodyReservesTable extends StatefulWidget {
  final TableEntity table;
  final DateTime selectedDate;
  final ScreenReservesOfTable widget;
  final List<ReserveEntity>? reserves;
  const BodyReservesTable(
      {super.key,
      required this.table,
      required this.selectedDate,
      required this.widget,
      this.reserves});

  @override
  State<BodyReservesTable> createState() => _BodyReservesTableState();
}

class _BodyReservesTableState extends State<BodyReservesTable> {
  @override
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
                        firstDate: DateTime.now(),
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
              child: Text(
                AppLocalizations.of(context)!.available_reservations_for_date(
                    getDate(selectedDate.toString())),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: widget.reserves?.length,
              itemBuilder: (context, index) {
                final reserve = widget.reserves![index];
                return CardReserve(reserve: reserve, widget: widget.widget);
              },
            ),
          ),
        ),
      ],
    );
  }
}
