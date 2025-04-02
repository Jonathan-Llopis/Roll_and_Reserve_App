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

/// Creates a row of stars with a rating.
///
/// The number of full stars is [rating.floor()], and if
/// [rating] is not a whole number, there will be a half star.
/// The remaining stars will be unfilled.
///
/// The stars are followed by a space and then the text
/// representation of the rating, with two decimal places.
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


/// Shows a material design date picker to the user and updates the [controller]
/// with the selected date in the format 'dd-MM-yyyy'.
///
/// The [context] is used to get the current locale and to show the date picker.
///
/// The [controller] is used to get the initial date and to update the text
/// with the selected date.
///
/// The initial date is either the current date or the date in the [controller].
///
/// The first date that can be selected is the current date and the last date
/// that can be selected is the current date plus one year.
///
/// If the user selects a date, the [controller] is updated with the selected
/// date in the format 'dd-MM-yyyy'.
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

/// Shows a material design time picker to the user and updates the [controller]
/// with the selected time in a human-readable format.
///
/// The [context] is used to show the time picker and to get the current
/// localization for formatting the time.
///
/// The [controller] is used to get the initial time and to update the text
/// with the selected time.
///
/// The initial time is either the current time or the time in the [controller].
///
/// If the user selects a time, the [controller] is updated with the selected
/// time formatted according to the current localization.

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

/// Validates a time for a reserve.
///
/// The [context] is used to get the current localization for formatting the
/// time.
///
/// The [value] is the time to be validated.
///
/// The [reserveBloc] is used to get all the reserves in the shop.
///
/// The [dateReserve] is the date of the reserve.
///
/// The [reservaHora] is the controller for the start time of the reserve.
///
/// The [otraHora] is the controller for the end time of the reserve.
///
/// The [update] flag is used to check if the reserve is being updated or not.
///
/// The [endTime] flag is used to check if the time is the end time of the
/// reserve.
///
/// The function returns a string with the error message if the time is not
/// valid, otherwise it returns null.
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

/// Checks if the user is in the shop location and confirms the reserve.
///
/// The [context] is the context of the widget.
/// The [idReserve] is the id of the reserve to confirm.
///
/// If the user is in the shop location, shows a dialog with a success message
/// and confirms the reserve by dispatching a [ConfirmReserveEvent].
/// If the user is not in the shop location, shows a dialog with an error message
/// and does not confirm the reserve.
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
/// Converts a date string with a numeric month to a string with the month's name.
/// 
/// The [date] should be in the format 'dd/MM', where 'MM' is the numeric representation of the month.
/// The [monthNames] list contains the names of the months, indexed from 0 to 11.
/// 
/// Returns a string with the day and the month's name in the format 'dd/MonthName'.

String monthStadistics(String date, List<String> monthNames) {

  List<String> dateParts = date.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);

  String monthName = monthNames[month - 1];
  return '$day/$monthName';
}

/// Converts a date range with numeric months to a text representation with month names.
/// 
/// The [dateRange] should be in the format 'dd/MM al dd/MM', where 'MM' is the numeric representation of the month.
/// The [monthNames] list contains the names of the months, indexed from 0 to 11.
/// 
/// Returns a string with the day and the month's name for both start and end dates in the format 'dd/MonthName al dd/MonthName'.

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

