import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/show_dialogs.dart';

class TablesShow extends StatefulWidget {
  final int idShop;
  const TablesShow({super.key, required this.idShop});

  @override
  State<TablesShow> createState() => _TablesShowState();
}

class _TablesShowState extends State<TablesShow> {
  
  @override
  Widget build(BuildContext context) {
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {   
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.tables != null) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tables?.length ?? 0,
                    itemBuilder: (context, index) {
                      final table = state.tables![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 5.0,
                          child: InkWell(
                            onTap: () {
                              showUpdateCreateTableDialog(
                                  context, widget.idShop, table);
                            },
                            borderRadius: BorderRadius.circular(16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mesa ${table.numberTable}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Juego desconocido',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: Colors.blueAccent,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 6.0),
                                      Text(
                                        'Jugadores: ${table.users.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Colors.grey[700],
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      Chip(
                                        label: Text(
                                            'Juego: ${'Juego desconocido'}'),
                                        backgroundColor: Colors.blue.shade100,
                                        labelStyle:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      Chip(
                                        label: Text(
                                            'Jugadores Totales: ${table.freePlaces}'),
                                        backgroundColor: Colors.green.shade100,
                                        labelStyle:
                                            TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Cancelar',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showUpdateCreateTableDialog(
                            context, widget.idShop, null);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child:
                          Text('Añadir', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        return const Center(child: Text('No se encontraron mesas'));
      }
    });
  }
}
