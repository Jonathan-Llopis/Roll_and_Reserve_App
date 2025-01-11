import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
  if (picked != null) {
    controller.text = DateFormat('dd-MM-yyyy').format(picked);
  }
}
