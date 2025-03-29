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
    TextEditingController reservaHora,
    TextEditingController otraHora,
    bool update,
    bool endTime) {
  String? error = validateHour(value, context);
  if (error != null) return error;
  if (!update &&
      isHourTaken(reserveBloc.state.reserves!, dateReserve, reservaHora.text,
        )) {
    return AppLocalizations.of(context)!.time_already_taken_that_day;
  }
  if (reservaHora.text.compareTo(otraHora.text) >= 0 && !endTime) {
    return AppLocalizations.of(context)!.start_time_must_be_less_than_end_time;
  }
  return null;
}

Future<void> checkUserLocation(BuildContext context, int idReserve) async {
  ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
  LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);

  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error(AppLocalizations.of(context)!.grant_camera_permission);
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error(
          AppLocalizations.of(context)!.location_service_disabled);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        AppLocalizations.of(context)!.location_permission_denied);
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  final double distanceInMeters = Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    shopBloc.state.shop!.latitude,
    shopBloc.state.shop!.longitude,
  );

  if (distanceInMeters <= 100) {
    Navigator.of(context).pop();
    confirmReserveDialog(
        context, AppLocalizations.of(context)!.reservation_confirmed, false);
    context.read<ReserveBloc>().add(ConfirmReserveEvent(
        idReserve: idReserve, idUser: loginBloc.state.user!.id));
  } else {
    Navigator.of(context).pop();
    confirmReserveDialog(
        context, AppLocalizations.of(context)!.not_in_shop_location, true);
  }
}
String monthStadistics(String date, List<String> monthNames) {

  List<String> dateParts = date.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);

  String monthName = monthNames[month - 1];
  return '$day/$monthName';
}

String convertMonthRangeToText(String dateRange, List<String> monthNames) {
  List<String> dates = dateRange.split(' al ');
  String startDate = dates[0];
  String endDate = dates[1];

  List<String> startParts = startDate.split('/');
  List<String> endParts = endDate.split('/');

  int startDay = int.parse(startParts[0]);
  int startMonth = int.parse(startParts[1]);
  int endDay = int.parse(endParts[0]);
  int endMonth = int.parse(endParts[1]);

  String startMonthName = monthNames[startMonth - 1];
  String endMonthName = monthNames[endMonth - 1];

  return '$startDay/$startMonthName al $endDay/$endMonthName';
}

