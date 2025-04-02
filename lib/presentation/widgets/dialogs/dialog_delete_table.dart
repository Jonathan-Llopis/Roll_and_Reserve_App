import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogoDeleteTable extends StatelessWidget {
  final int idTable;
  final int idShop;
  final TableBloc tableBloc;
  const DialogoDeleteTable(
      {super.key, required this.idTable, required this.idShop, required this.tableBloc});

  @override
  /// Returns a dialog to delete a table
  ///
  /// The dialog shows a message asking to confirm the deletion of the table.
  /// The user can cancel or accept.
  /// If the user accepts, the table is deleted and the dialog is closed.
  /// The user is returned to the shop table list.
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_table,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30,
            )),
        content: Text(
          AppLocalizations.of(context)!.confirm_delete_table,
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: AppTheme.textButtonCancelStyle,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            style: AppTheme.textButtonAcceptStyle,
            onPressed: () {
              tableBloc.add(
                DeleteTableEvent(
                  idTable: idTable,
                  idShop: idShop,
                ),
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.accept),
          ),
        ],
      );
    });
  }
}
