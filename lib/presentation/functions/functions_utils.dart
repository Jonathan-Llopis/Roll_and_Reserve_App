import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';

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
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: const Locale('es', 'ES'),
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

String? validateTime(
    String? value,
    ReserveBloc reserveBloc,
    DateTime dateReserve,
    TextEditingController startHour,
    TextEditingController endHour) {
  String? error = validateHour(value);
  if (error != null) return error;
  if (isHourTaken(reserveBloc.state.reserves!, dateReserve,
      startHour.text, endHour.text)) {
    return 'La hora ya está cogida ese día';
  }
  if (startHour.text.compareTo(endHour.text) >= 0) {
    return 'La hora de inicio debe ser menor que la de fin';
  }
  return null;
}
