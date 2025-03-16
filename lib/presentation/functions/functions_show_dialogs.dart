import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_change_language.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_confirm_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_review.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_create_update_table.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_delete_shop.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_email_sent.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_error_datePicker.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_logout.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_reset_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_update_password.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_user_edit.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_delete_table.dart';

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

Future<void> deleteShop(BuildContext context, int idShop, ShopBloc shopBloc) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogDeleteShop(
          idShop: idShop,
          shopBloc: shopBloc,
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
        tableBloc: BlocProvider.of<TableBloc>(context),
      );
    },
  );
}

Future<void> createReview(BuildContext context, ReviewBloc reviewBloc,
 int? idShop, String? idUser) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogCreateReview(
          idShop: idShop ?? 0,
          reviewBloc: reviewBloc,
          idUser: idUser ?? "",
        );
      });
}

Future<void> deleteTable(
    BuildContext context, int idTable, int idShop, TableBloc tableBloc) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogoDeleteTable(
          idTable: idTable,
          idShop: idShop,
          tableBloc: tableBloc,
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

Future<void> confirmReserveDialog(
    BuildContext context, String mensaje, bool error) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogConfirmReserve(mensaje: mensaje, error: error);
      });
}

Future<void> errorDatePicker(
    BuildContext context, String mensaje, int idShop) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogErrorDatepicker(mensaje: mensaje, idShop: idShop);
      });
}
