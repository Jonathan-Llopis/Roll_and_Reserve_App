import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';

String? basicValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo obligatorio';
  }
  return null;
}
String? basicValidationWithNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo obligatorio';
  }
  if (!value.contains(RegExp(r'^[0-9]+$'))) {
    return 'Debe ser un número';
  }
  return null;
}

String? validateSelectedValue(Object? value) {
  if (value == null) {
    return "Selecciona una opción";
  }
  return null;
}

String? validateHour(String? value) {
  if (value == null || value.isEmpty) {
    return "Este campo es obligatorio";
  }
  final regex = RegExp(r'^\d{2}:\d{2}$');
  if (!regex.hasMatch(value)) {
    return "El formato debe ser HH:MM";
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

int horaAMinutos(String hora) {
  final partes = hora.split(":");
  final horas = int.parse(partes[0]);
  final minutos = int.parse(partes[1]);
  return horas * 60 + minutos;
}

bool isHourTaken(List<ReserveEntity> reservas, DateTime fecha, String horaInicio, String horaFin) {
  final horaInicioMinutos = horaAMinutos(horaInicio);
  final horaFinMinutos = horaAMinutos(horaFin);

  for (var reserva in reservas) {
    if (DateFormat('dd - MM - yyyy').parse(reserva.dayDate) == fecha) {
      final reservaHoraInicioMinutos = horaAMinutos(reserva.horaInicio);
      final reservaHoraFinMinutos = horaAMinutos(reserva.horaFin);

      if ((horaInicioMinutos >= reservaHoraInicioMinutos && horaInicioMinutos < reservaHoraFinMinutos) ||
          (horaFinMinutos > reservaHoraInicioMinutos && horaFinMinutos <= reservaHoraFinMinutos) ||
          (horaInicioMinutos <= reservaHoraInicioMinutos && horaFinMinutos >= reservaHoraFinMinutos)) {
        return true;
      }
    }
  }
  return false;
}