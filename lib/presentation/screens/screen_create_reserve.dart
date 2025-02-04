import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/body_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

class ScreenCreateReserve extends StatefulWidget {
  const ScreenCreateReserve(
      {super.key,
      required this.idTable,
      required this.idShop,
      required this.searchDateTimeString});
  final int idTable;
  final int idShop;
  final String searchDateTimeString;

  @override
  State<ScreenCreateReserve> createState() => _ScreenCreateReserveState();
}

class _ScreenCreateReserveState extends State<ScreenCreateReserve> {
  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = context.read<ReserveBloc>();
    DateTime searchDateTime =
        DateFormat("yyyy-MM-dd").parse(widget.searchDateTimeString);
    return DefaultScaffold(
        body: BodyCreateReserve(
      idTable: widget.idTable,
      reserveBloc: reserveBloc,
      idShop: widget.idShop,
      searchDateTime: searchDateTime,
    ));
  }
}
