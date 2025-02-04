import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

class TableSelectionCheckbox extends StatefulWidget {
  final List<TableEntity> tables;
  final Function(List<int>) onSelectionChanged;

  const TableSelectionCheckbox({
    required this.tables,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  State<TableSelectionCheckbox> createState() => _TableSelectionCheckboxState();
}

class _TableSelectionCheckboxState extends State<TableSelectionCheckbox> {
  final List<int> _selectedTableIds = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.select_tables_to_occupy),
        Wrap(
          children: widget.tables.map((table) {
            return CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.table_number(table.numberTable)),
              value: _selectedTableIds.contains(table.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedTableIds.add(table.id);
                  } else {
                    _selectedTableIds.remove(table.id);
                  }
                  widget.onSelectionChanged(_selectedTableIds);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
