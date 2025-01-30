import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TableSelectionCheckbox extends StatefulWidget {
  final List<int> tableIds;
  final Function(List<int>) onSelectionChanged;

  const TableSelectionCheckbox({
    required this.tableIds,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  State<TableSelectionCheckbox> createState() => _TableSelectionCheckboxState();
}

class _TableSelectionCheckboxState extends State<TableSelectionCheckbox> {
  List<int> _selectedTableIds = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selecciona las mesas a ocupar"),
        Wrap(
          children: widget.tableIds.map((tableId) {
            return CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.table_number(tableId)),
              value: _selectedTableIds.contains(tableId),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedTableIds.add(tableId);
                  } else {
                    _selectedTableIds.remove(tableId);
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
