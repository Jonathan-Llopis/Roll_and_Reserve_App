import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Row buildStars(double rating) {
  List<Widget> stars = [];
  int fullStars = rating.floor();
  for (int i = 0; i < 5; i++) {
    if (i < fullStars) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: 16));
    } else if (i == fullStars && rating - fullStars >= 0.5) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: 16));
    } else {
      stars.add(Icon(Icons.star, color: Colors.grey, size: 16));
    }
  }
  stars.add(SizedBox(width: 4.0));
  stars.add(Text('(${rating.toStringAsFixed(2)})'));
  return Row(children: stars);
}

Future<void> selectDate(
    BuildContext context, TextEditingController controller) async {
  LanguageBloc languageBloc = BlocProvider.of<LanguageBloc>(context);
  final DateTime? picked = await showDatePicker(
    locale: languageBloc.state.locale,
    context: context,
    initialDate: controller.text == ""
        ? DateTime.now()
        : DateFormat('dd-MM-yyyy').parse(controller.text),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
  if (picked != null) {
    controller.text = DateFormat('dd-MM-yyyy').format(picked);
  }
}

Future<void> selectTime(
    BuildContext context, TextEditingController controller) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: controller.text != ""
        ? TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(controller.text))
        : TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
  if (pickedTime != null) {
    final localizations = MaterialLocalizations.of(context);
    final formattedTime =
        localizations.formatTimeOfDay(pickedTime, alwaysUse24HourFormat: false);
    controller.text = formattedTime;
  }
}

String? validateTime(
    BuildContext context,
    String? value,
    ReserveBloc reserveBloc,
    DateTime dateReserve,
    TextEditingController startHour,
    TextEditingController endHour) {
  String? error = validateHour(value, context);
  if (error != null) return error;
  if (isHourTaken(
      reserveBloc.state.reserves!, dateReserve, startHour.text, endHour.text)) {
    return AppLocalizations.of(context)!.time_already_taken_that_day;
  }
  if (startHour.text.compareTo(endHour.text) >= 0) {
    return AppLocalizations.of(context)!.start_time_must_be_less_than_end_time;
  }
  return null;
}

Future<void> checkUserLocation(BuildContext context, int idReserve) async {
  ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
  LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

  bool serviceEnabled;
  LocationPermission permission;

  // Verificar si los servicios de ubicación están habilitados
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Los servicios de ubicación no están habilitados, no se puede continuar
    return Future.error('El servicio de ubicación está deshabilitado.');
  }

  // Verificar los permisos de ubicación
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Los permisos están denegados, no se puede continuar
      return Future.error('Los permisos de ubicación están denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Los permisos están denegados permanentemente, no se puede continuar
    return Future.error(
        'Los permisos de ubicación están denegados permanentemente.');
  }

  // Obtener la posición actual del usuario
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final double distanceInMeters = Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    shopBloc.state.shop!.latitude,
    shopBloc.state.shop!.longitude,
  );

  if (distanceInMeters <= 100) {
    confirmReserveDialog(context, 'Tu Reserva ha sido confirmada!', false);
    context.read<ReserveBloc>().add(ConfirmReserveEvent(
        idReserve: idReserve, idUser: loginBloc.state.user!.id));
  } else {
    confirmReserveDialog(
        context, 'No estás en la ubicación de la tienda', true);
  }
}
