import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';

class ScreenReservesOfTable extends StatefulWidget {
  final int idTable;
  final int idShop;
  const ScreenReservesOfTable(
      {super.key, required this.idTable, required this.idShop});

  @override
  State<ScreenReservesOfTable> createState() => _ScreenReservesOfTableState();
}

class _ScreenReservesOfTableState extends State<ScreenReservesOfTable> {
  DateTime? _selectedDate;
  @override
  void initState() {
    
    _selectedDate = DateTime.now();
    context.read<ReserveBloc>().add(
          GetReserveByDateEvent(
              dateReserve: _selectedDate!, idTable: widget.idTable),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
      if (state.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (state.errorMessage != null) {
        return Scaffold(
          appBar: DefaultAppBar(scaffoldKey: scaffoldKey,),
          body: Center(
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        );
      } else if (state.reserves != null) {
        return Scaffold(
          key: scaffoldKey,
          appBar: DefaultAppBar(scaffoldKey: scaffoldKey, ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Mesa ${widget.idTable}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Reservas disponibles",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.book_online,
                            size: 48, color: Colors.green),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              locale: const Locale('es', 'ES'),
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                              // ignore: use_build_context_synchronously
                              context.read<ReserveBloc>().add(
                                    GetReserveByDateEvent(
                                        dateReserve: _selectedDate!,
                                        idTable: widget.idTable),
                                  );
                            }
                          },
                          child: const Text('Filtrar por fecha'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Reservas Disponibles',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.builder(
                    itemCount: state.reserves?.length,
                    itemBuilder: (context, index) {
                      final reserve = state.reserves![index];
                      return CardReserve(reserve: reserve, widget: widget);
                    },
                  ),
                ),
              ),
            ],
          ),
          endDrawer: const DrawerMain(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              createReserve(context, widget.idTable, _selectedDate!);
            },
            child: const Icon(Icons.add),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
