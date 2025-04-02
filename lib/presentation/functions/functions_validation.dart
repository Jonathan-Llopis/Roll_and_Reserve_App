import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Basic validation to check if a value is not null or empty
/// and if not, return a message indicating that the field is required.
///
/// [value] The value to check.
/// [context] The context of the widget.
///
/// Returns a message if the value is null or empty, otherwise, it returns null.
///
String? basicValidation(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}
/// Basic validation to check if a value is not null or empty
/// and if not, it must contain only numbers.
///
/// [value] The value to check.
/// [context] The context of the widget.
///
/// Returns a message if the value is null or empty, or if it does not contain
/// only numbers, otherwise, it returns null.
String? basicValidationWithNumber(String? value, BuildContext context){
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  if (!value.contains(RegExp(r'^[0-9]+$'))) {
    return AppLocalizations.of(context)!.must_be_a_number;
  }
  return null;
}

/// Validate if a value is not null or empty.
///
/// [value] The value to check.
/// [context] The context of the widget.
///
/// Returns a message if the value is null or empty, otherwise, it returns null.
String? validateSelectedValue(Object? value, BuildContext context) {
  if (value == null) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}

/// Validate if a value is a valid hour in the format HH:MM.
///
/// [value] The value to check.
/// [context] The context of the widget.
///
/// Returns a message if the value is null or empty, or if it does not match the
/// format HH:MM, otherwise, it returns null.
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

/// Returns true if the given [value] contains at least one number.
bool hasNumber(String value) {
  return value.contains(RegExp(r'\d'));
}

/// Returns true if the given [value] contains at least one uppercase letter.

bool hasUppercaseLetter(String value) {
  return value.contains(RegExp(r'[A-Z]'));
}

/// Returns true if the given [value] contains at least one lowercase letter.
bool hasLowercaseLetter(String value) {
  return value.contains(RegExp(r'[a-z]'));
}

/// Returns true if the given [value] is a valid email address.
///
/// The email address is validated using the following regular expression:
///
///     ^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$
///
/// This regular expression matches most common email address formats, but it
/// may not match all possible valid email addresses.
bool isEmailValid(String value) {
  return RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(value);
}

/// Validates the provided username.
///
/// Checks if the [value] is null or empty and returns a localized
/// message indicating the field is required. It also checks if the
/// username is already used by accessing the [loginBloc] state, and
/// returns a localized message if the username is in use.
///
/// [value] The username to validate.
/// [loginBloc] The bloc containing the login state.
/// [context] The build context for localization.
///
/// Returns a localized error message if the username is invalid or
/// already in use, otherwise returns null.

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

/// Validates the provided name.
///
/// Checks if the [value] is null or empty and returns a localized
/// message indicating the field is required.
///
/// [value] The name to validate.
/// [context] The build context for localization.
///
/// Returns a localized error message if the name is invalid, otherwise
/// returns null.
String? validateName(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.required_field;
  }
  return null;
}

/// Validates the provided email address.
///
/// Checks if the [value] is null or empty and returns a localized message
/// indicating the field is required. It also checks if the email address is
/// valid using the [isEmailValid] function, and returns a localized message if
/// the email is invalid. Finally, it checks if the email is already used by
/// accessing the [loginBloc] state, and returns a localized message if the
/// email is in use.
///
/// [value] The email address to validate.
/// [loginBloc] The bloc containing the login state.
/// [context] The build context for localization.
///
/// Returns a localized error message if the email is invalid or already in use,
/// otherwise returns null.
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

/// Validates the provided password.
///
/// Checks if the [value] is null or empty and returns a localized message
/// indicating the field is required. It also checks if the password is valid
/// according to the following rules:
/// - The password must be at least 8 characters long.
/// - The password must contain at least one number.
/// - The password must contain at least one uppercase letter.
/// - The password must contain at least one lowercase letter.
///
/// [value] The password to validate.
/// [context] The build context for localization.
///
/// Returns a localized error message if the password is invalid, otherwise
/// returns null.
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

/// Validates the provided confirmation password.
///
/// Checks if the [value] is null or empty and returns a localized
/// message indicating the field is required. It also checks if the
/// confirmation password is valid according to the following rules:
/// - The confirmation password must be at least 8 characters long.
/// - The confirmation password must contain at least one number.
/// - The confirmation password must contain at least one uppercase letter.
/// - The confirmation password must contain at least one lowercase letter.
/// - The confirmation password must match the original password.
///
/// [value] The confirmation password to validate.
/// [passwordController] The controller holding the original password.
/// [context] The build context for localization.
///
/// Returns a localized error message if the confirmation password is invalid
/// or does not match the original password, otherwise returns null.

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

/// Validates the provided current password.
///
/// Checks if the [value] is null or empty and returns a localized message
/// indicating the field is required. It also checks if the password is valid
/// by checking the `validatePassword` and `errorMessage` properties of the
/// [loginBloc] state. If the password is invalid or the validation error
/// message is not null, it returns a localized message indicating the password
/// is incorrect. If the `validatePassword` property is null, it returns a
/// localized message indicating there was an error validating the password.
///
/// [value] The current password to validate.
/// [loginBloc] The bloc containing the login state.
/// [context] The build context for localization.
///
/// Returns a localized error message if the current password is invalid,
/// otherwise returns null.
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

/// Converts a time in the format "HH:MM" to minutes.
///
/// [hora] The time to convert.
///
/// Returns the time in minutes.
int horaAMinutos(String hora) {
  final partes = hora.split(":");
  final horas = int.parse(partes[0]);
  final minutos = int.parse(partes[1]);
  return horas * 60 + minutos;
}

/// Checks if the given time is already taken by a reserve.
///
/// [reservas] The list of reserves to check.
/// [fecha] The date to check.
/// [horaReserva] The time to check.
///
/// Returns true if the given time is taken, false otherwise.
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

/// Validates a table number input for a shop.
///
/// Checks if the [value] is null or empty and returns a localized message
/// indicating the field is required. It also checks if the value contains
/// only numbers and returns a localized message if it does not. Additionally,
/// it verifies if the table number already exists in the [currentShop].
///
/// [value] The table number to validate.
/// [currentShop] The shop entity containing existing table numbers.
/// [context] The build context for localization.
///
/// Returns a localized error message if the table number is invalid or
/// already exists, otherwise returns null.

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