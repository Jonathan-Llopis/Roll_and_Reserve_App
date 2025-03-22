import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? basicValidation(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}
String? basicValidationWithNumber(String? value, BuildContext context){
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  if (!value.contains(RegExp(r'^[0-9]+$'))) {
    return AppLocalizations.of(context)!.must_be_a_number;
  }
  return null;
}

String? validateSelectedValue(Object? value, BuildContext context) {
  if (value == null) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}

String? validateHour(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  final regex = RegExp(r'^\d{2}:\d{2}$');
  if (!regex.hasMatch(value)) {
    return AppLocalizations.of(context)!.format_must_be_hh_mm;
  }
  
  return null;
}

bool hasNumber(String value) {
  return value.contains(RegExp(r'\d'));
}

bool hasUppercaseLetter(String value) {
  return value.contains(RegExp(r'[A-Z]'));
}

bool hasLowercaseLetter(String value) {
  return value.contains(RegExp(r'[a-z]'));
}

bool isEmailValid(String value) {
  return RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(value);
}

String? validateUserName(String? value, LoginBloc loginBloc, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  final isNameUsed = loginBloc.state.isNameUsed;
  if (isNameUsed != null && isNameUsed) {
    return AppLocalizations.of(context)!.name_already_in_use;
  }
  return null;
}

String? validateName(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}

String? validateEmail(String? value, LoginBloc loginBloc, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  if (!isEmailValid(value)) {
    return AppLocalizations.of(context)!.email_invalid;
  }
  final isEmailUsed = loginBloc.state.isEmailUsed;
  if (isEmailUsed != null && isEmailUsed) {
    return AppLocalizations.of(context)!.email_already_in_use;
  }
  return null;
}

String? validatePassword(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  if (value.length < 8) {
    return AppLocalizations.of(context)!.password_must_be_at_least_8_characters;
  }
  if (!hasNumber(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_number;
  }
  if (!hasUppercaseLetter(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_uppercase_letter;
  }
  if (!hasLowercaseLetter(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_lowercase_letter;
  }
  return null;
}

String? validateConfirmPassword(
    String? value, TextEditingController passwordController, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  if (value.length < 8) {
    return AppLocalizations.of(context)!.password_must_be_at_least_8_characters;
  }
  if (!hasNumber(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_number;
  }
  if (!hasUppercaseLetter(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_uppercase_letter;
  }
  if (!hasLowercaseLetter(value)) {
    return AppLocalizations.of(context)!.password_must_contain_at_least_one_lowercase_letter;
  }
  if (value != passwordController.text) {
    return  AppLocalizations.of(context)!.passwords_do_not_match;
  }
  return null;
}

String? validateCurrentPassword(String? value, LoginBloc loginBloc, BuildContext context) {
  if (value == null || value.isEmpty) {
    return  AppLocalizations.of(context)!.required_field;
  } else {
    final validatePassword = loginBloc.state.validatePassword;
    if (validatePassword != null) {
      if (!validatePassword || loginBloc.state.errorMessage != null) {
        return AppLocalizations.of(context)!.password_is_incorrect;
      }
    } else {
      return  AppLocalizations.of(context)!.error_validating_password;
    }
  }
  return null;
}

int horaAMinutos(String hora) {
  final partes = hora.split(":");
  final horas = int.parse(partes[0]);
  final minutos = int.parse(partes[1]);
  return horas * 60 + minutos;
}

bool isHourTaken(List<ReserveEntity> reservas, DateTime fecha, String horaReserva,) {
  final horaReservaMinutos = horaAMinutos(horaReserva);

  for (var reserva in reservas) {
    if (DateFormat('dd - MM - yyyy').parse(reserva.dayDate) == fecha) {
      final reservaHoraInicioMinutos = horaAMinutos(reserva.horaInicio);
      final reservaHoraFinMinutos = horaAMinutos(reserva.horaFin);

      if (horaReservaMinutos >= reservaHoraInicioMinutos && horaReservaMinutos < reservaHoraFinMinutos) {
        return true;
      }
    }
  }
  return false;
}

String? basicValidationTable(String? value, ShopEntity currentShop, BuildContext context) {
  if (value == null || value.isEmpty) {
    return  AppLocalizations.of(context)!.required_field;
  }
  if (!value.contains(RegExp(r'^[0-9]+$'))) {
    return  AppLocalizations.of(context)!.must_be_a_number;
  }
  if(currentShop.tablesShop.any((element) => element == int.parse(value))){
    return  AppLocalizations.of(context)!.table_number_already_exists;

  }
  return null;
}