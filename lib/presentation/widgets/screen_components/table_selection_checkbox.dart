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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
          child: Text(
            AppLocalizations.of(context)!.select_tables_to_occupy,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: widget.tables.map((table) {
            final isSelected = _selectedTableIds.contains(table.id);

            return InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTableIds.remove(table.id);
                  } else {
                    _selectedTableIds.add(table.id);
                  }
                  widget.onSelectionChanged(_selectedTableIds);
                });
              },
              child: Container(
                width: 160.0,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withOpacity(0.1)
                      : colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedTableIds.add(table.id);
                          } else {
                            _selectedTableIds.remove(table.id);
                          }
                          widget.onSelectionChanged(_selectedTableIds);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      side: BorderSide(
                        color: colorScheme.outline.withOpacity(0.4),
                        width: 1.5,
                      ),
                      checkColor: colorScheme.onPrimary,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return colorScheme.primary;
                          }
                          return Colors.transparent;
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      AppLocalizations.of(context)!
                          .table_number(table.numberTable),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
