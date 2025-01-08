import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';

class DialogCreateupdateTable extends StatefulWidget {
  final int idShop;
  final TableEntity? table;
  const DialogCreateupdateTable({
    required this.idShop,
    this.table,
    super.key,
  });

  @override
  State<DialogCreateupdateTable> createState() => _CreateUpdateTableState();
}

class _CreateUpdateTableState extends State<DialogCreateupdateTable> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tableNameController = TextEditingController();
  final TextEditingController _freeSpacesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.table == null) {
      _tableNameController.text = '';
      _freeSpacesController.text = '';
    } else {
      _tableNameController.text = widget.table!.numberTable.toString();
      _freeSpacesController.text = widget.table!.freePlaces;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Crear Nueva Mesa",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _tableNameController,
                  decoration:
                      const InputDecoration(labelText: "Numero de la Mesa"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa un numero para la mesa";
                    } else if (int.tryParse(value) == null) {
                      return "Por favor ingresa un número válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _freeSpacesController,
                  decoration:
                      const InputDecoration(labelText: "Espacios Vacíos"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa la cantidad de espacios vacíos";
                    } else if (int.tryParse(value) == null) {
                      return "Por favor ingresa un número válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar"),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (widget.table != null) {
                            context.read<TableBloc>().add(UpdateTableEvent(
                                table: TableEntity(
                                    id: widget.table!.id,
                                    numberTable:
                                        int.parse(_tableNameController.text),
                                    freePlaces: _freeSpacesController.text,
                                    stats: "",
                                    users: [],
                                    reserves: [],
                                    idShop: widget.idShop)));
                          } else {
                            context.read<TableBloc>().add(CreateTableEvent(
                                  table: TableEntity(
                                      id: 0,
                                      numberTable:
                                          int.parse(_tableNameController.text),
                                      freePlaces: _freeSpacesController.text,
                                      stats: "",
                                      users: [],
                                      reserves: [],
                                      idShop: widget.idShop),
                                ));
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Guardar"),
                    ),
                    widget.table == null
                        ? Container()
                        : Center(
                            child: TextButton(
                              onPressed: () {
                                context.read<TableBloc>().add(DeleteTableEvent(
                                    idTable: widget.table!.id,
                                    idShop: widget.idShop));
                                Navigator.of(context).pop();
                              },
                              child: Text('Eliminar tienda',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
