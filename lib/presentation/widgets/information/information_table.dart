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
