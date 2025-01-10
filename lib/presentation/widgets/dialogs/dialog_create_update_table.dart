import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';

class DialogCreateUpdateTable extends StatefulWidget {
  final int idShop;
  final TableEntity? table;

  const DialogCreateUpdateTable({
    required this.idShop,
    this.table,
    super.key,
  });

  @override
  State<DialogCreateUpdateTable> createState() =>
      _DialogCreateUpdateTableState();
}

class _DialogCreateUpdateTableState extends State<DialogCreateUpdateTable> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tableNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tableNameController.text = widget.table?.numberTable.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.table == null ? "Crear Nueva Mesa" : "Editar Mesa",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _tableNameController,
                  decoration: InputDecoration(
                    labelText: "Número de la Mesa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa un número para la mesa";
                    } else if (int.tryParse(value) == null) {
                      return "Por favor ingresa un número válido";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (widget.table != null) {
                            context.read<TableBloc>().add(UpdateTableEvent(
                                  table: TableEntity(
                                    id: widget.table!.id,
                                    numberTable:
                                        int.parse(_tableNameController.text),
                                    stats: "",
                                    reserves: [],
                                    idShop: widget.idShop,
                                  ),
                                ));
                          } else {
                            context.read<TableBloc>().add(CreateTableEvent(
                                  table: TableEntity(
                                    id: 0,
                                    numberTable:
                                        int.parse(_tableNameController.text),
                                    stats: "",
                                    reserves: [],
                                    idShop: widget.idShop,
                                  ),
                                ));
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Guardar"),
                    ),
                  ],
                ),
                if (widget.table != null) ...[
                  const SizedBox(height: 24.0),
                  Divider(color: Colors.grey.shade400),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          context.read<TableBloc>().add(
                                DeleteTableEvent(
                                  idTable: widget.table!.id,
                                  idShop: widget.idShop,
                                ),
                              );
                          Navigator.of(context).pop();
                        },
                        child: const Text("Eliminar Mesa"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.go(
                            '/user/shop/table/${widget.table!.id}${widget.idShop}',
                          );
                        },
                        child: const Text("Gestionar Reservas"),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
