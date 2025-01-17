import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogCreateUpdateTable extends StatefulWidget {
  final ShopEntity currentShop;
  final TableEntity? table;

  const DialogCreateUpdateTable({
    required this.currentShop,
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
                  widget.table == null ?  AppLocalizations.of(context)!.create_new_table :  AppLocalizations.of(context)!.edit_table,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _tableNameController,
                  decoration: InputDecoration(
                    labelText:  AppLocalizations.of(context)!.table_number_text,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    String? error =
                        basicValidationTable(value, widget.currentShop, context);
                    return error;
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
                      child: Text(AppLocalizations.of(context)!.cancel),
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
                                    idShop: widget.currentShop.id,
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
                                    idShop: widget.currentShop.id,
                                  ),
                                ));
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child:  Text( AppLocalizations.of(context)!.save),
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
                          deleteTable(
                              context, widget.table!.id, widget.currentShop.id);
                        },
                        child:  Text( AppLocalizations.of(context)!.delete_table),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.go(
                            '/user/shop/${widget.currentShop.id}/table/${widget.table!.id}',
                          );
                        },
                        child:  Text( AppLocalizations.of(context)!.manage_reservations),
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
