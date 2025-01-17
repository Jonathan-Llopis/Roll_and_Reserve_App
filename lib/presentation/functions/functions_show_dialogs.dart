import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_change_language.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_review.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_update_table.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_delete_shop.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_email_sent.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_logout.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_reset_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_update_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_user_edit.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialogo_delete_table.dart';

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
        return const DialogLogOut();
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
        return DialogDeleteShop(
          idShop: idShop,
        );
      });
}

Future<void> showUpdateCreateTableDialog(
    BuildContext context, ShopEntity currentShop, TableEntity? table) {
  return showDialog(
    context: context,
    builder: (context) {
      return DialogCreateUpdateTable(
        currentShop: currentShop,
        table: table,
      );
    },
  );
}

Future<void> createReserve(
    BuildContext context, int idTable, DateTime dateReserve) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogCreateReserve(
          idTable: idTable,
          dateReserve: dateReserve,
        );
      });
}

Future<void> createReview(BuildContext context, int idShop) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogCreateReview(
          idShop: idShop,
        );
      });
}

Future<void> deleteTable(BuildContext context, int idTable, int idShop) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogoDeleteTable(
          idTable: idTable,
          idShop: idShop,
        );
      });
}

Future<void> changeLanguage(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return ChangeLanguageDialog();
      });
}
