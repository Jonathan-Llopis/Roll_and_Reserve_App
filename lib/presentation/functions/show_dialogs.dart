import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_email_sent.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_logout.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_reset_password.dart';


Future<void> mostrarResetPassword(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const DialogResetPassword();
      });
}

Future<void> mostrarResetEmail(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const DialogEmailSent();
      });
}


Future<void> mostrarLogOut(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const LogOutUser();
      });
}
