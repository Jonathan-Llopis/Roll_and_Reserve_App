import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_review.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_update_table.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_delete_shop.dart';
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

Future<void> deleteShop(BuildContext context, int idShop) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogDeleteShop(idShop: idShop,);
      });
}

Future<void> showUpdateCreateTableDialog(BuildContext context, int idShop, TableEntity? table) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogCreateUpdateTable(idShop: idShop,table: table,);
      },
    );
  }

Future<void> createReserve(BuildContext context, int idTable) {
  return showDialog(
      context: context,
      builder: (context) {
        return ReserveFormDialog(idTable: idTable);
      });
}

Future<void> createReview(BuildContext context, int idShop) {
  return showDialog(
      context: context,
      builder: (context) {
        return ReviewDialog(idShop: idShop,);
      });
}



