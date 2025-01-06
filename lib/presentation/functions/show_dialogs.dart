import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_email_sent.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_logout.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_reset_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_update_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_user_edit.dart';


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

Future<void> mostrarUserEdit(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const DialogoUserSettings();
      });
}
Future<void> updatePassword(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const DialogoUpdatePassword();
      });
}



