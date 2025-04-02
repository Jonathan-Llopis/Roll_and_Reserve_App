import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationTable extends StatelessWidget {
  const InformationTable({
    super.key,
    required this.table,
  });

  final TableEntity table;

  @override
  /// Builds the UI for the information of a table.
  ///
  /// The widget is divided into three parts: a title with the number of the
  /// table, a section with the number of reservations, and a section with a
  /// tag with the status of the table.
  ///
  /// The title is styled with [AppTheme.textButtonAcceptStyle].
  ///
  /// The number of reservations section shows the number of reservations of
  /// the table.
  ///
  /// The tag section shows a tag with the status of the table. If the table
  /// has reservations, the tag is green and shows the number of reservations.
  /// If the table does not have reservations, the tag is gray and shows the
  /// message 'No reservations'.
  ///
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.table_number(table.numberTable),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
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
                AppLocalizations.of(context)!
                    .reservations(table.reserves.length),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  AppLocalizations.of(context)!
                      .reservations(table.reserves.length),
                ),
                backgroundColor: Colors.green.shade100,
                labelStyle: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
