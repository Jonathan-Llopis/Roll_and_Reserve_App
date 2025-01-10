import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';

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

String? validateUserName(String? value, LoginBloc loginBloc) {
  if (value == null || value.isEmpty) {
    return 'El nombre es obligatorio';
  }
  final isNameUsed = loginBloc.state.isNameUsed;
  if (isNameUsed != null && isNameUsed) {
    return 'El nombre ya está en uso.';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'El nombre es obligatorio';
  }
  return null;
}

String? validateEmail(String? value, LoginBloc loginBloc) {
  if (value == null || value.isEmpty) {
    return 'El email es obligatorio';
  }
  if (!isEmailValid(value)) {
    return 'El correo electrónico no es válido';
  }
  final isEmailUsed = loginBloc.state.isEmailUsed;
  if (isEmailUsed != null && isEmailUsed) {
    return 'El email ya está en uso.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  if (!hasNumber(value)) {
    return 'La contraseña debe contener al menos un número';
  }
  if (!hasUppercaseLetter(value)) {
    return 'La contraseña debe contener al menos una letra mayúscula';
  }
  if (!hasLowercaseLetter(value)) {
    return 'La contraseña debe contener al menos una letra minúscula';
  }
  return null;
}

String? validateConfirmPassword(
    String? value, TextEditingController passwordController) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  if (!hasNumber(value)) {
    return 'La contraseña debe contener al menos un número';
  }
  if (!hasUppercaseLetter(value)) {
    return 'La contraseña debe contener al menos una letra mayúscula';
  }
  if (!hasLowercaseLetter(value)) {
    return 'La contraseña debe contener al menos una letra minúscula';
  }
  if (value != passwordController.text) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}

String? validateCurrentPassword(String? value, LoginBloc loginBloc) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  } else {
    final validatePassword = loginBloc.state.validatePassword;
    if (validatePassword != null) {
      if (!validatePassword || loginBloc.state.errorMessage != null) {
        return 'La contraseña no es correcta';
      }
    } else {
      return 'Error al validar la contraseña';
    }
  }
  return null;
}
