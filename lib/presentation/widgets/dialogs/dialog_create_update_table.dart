import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
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
  final TableBloc tableBloc;

  const DialogCreateUpdateTable({
    required this.currentShop,
    required this.tableBloc,
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
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.table == null
                            ? loc.create_new_table
                            : loc.edit_table,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.close, color: theme.colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _tableNameController,
                  decoration: InputDecoration(
                    labelText: loc.table_number_text,
                    prefixIcon:
                        Icon(Icons.numbers, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    floatingLabelStyle:
                        TextStyle(color: theme.colorScheme.primary),
                  ),
                  validator: (value) =>
                      basicValidationTable(value, widget.currentShop, context),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: AppTheme.textButtonCancelStyle,
                        child: Text(loc.cancel)),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      icon: const Icon(Icons.save, size: 20, color: Color(0xFF00695C)),
                      label: Text(loc.save),
                      style: AppTheme.textButtonAcceptStyle,
                      onPressed: _submitForm,
                    ),
                  ],
                ),
                if (widget.table != null) ...[
                  const SizedBox(height: 24),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.calendar_month, size: 20),
                    label: Text(loc.manage_reservations),
                    style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12)),
                    onPressed: () => context.go(
                        '/user/shop/${widget.currentShop.id}/table/${widget.table!.id}'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: Icon(Icons.delete, color: theme.colorScheme.error),
                    label: Text(loc.delete_table,
                        style: TextStyle(color: theme.colorScheme.error)),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: theme.colorScheme.error.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12)),
                    onPressed: () => deleteTable(context, widget.table!.id,
                        widget.currentShop.id, widget.tableBloc),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newTable = TableEntity(
        id: widget.table?.id ?? 0,
        numberTable: int.parse(_tableNameController.text),
        stats: "",
        reserves: [],
        idShop: widget.currentShop.id,
      );

      widget.tableBloc.add(widget.table == null
          ? CreateTableEvent(table: newTable)
          : UpdateTableEvent(table: newTable));
      Navigator.pop(context);
    }
  }
}
