import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';

class DialogEmailSent extends StatelessWidget {
  const DialogEmailSent({super.key});

  @override
  /// A dialog that shows a message when the reset password email is sent.
  ///
  /// It shows a message that indicates the email has been sent.
  /// There is only one action, which is to accept and close the dialog.
  ///
  Widget build(BuildContext context) {
    return AlertDialog(
      content:  Text(
         AppLocalizations.of(context)!.email_sent_reset_password,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: AppTheme.textButtonAcceptStyle,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.accept),
        ),
      ],
    );
  }
}
