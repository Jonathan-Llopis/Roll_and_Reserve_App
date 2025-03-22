import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/body_create_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

class ScreenCreateReserve extends StatefulWidget {
  const ScreenCreateReserve(
      {super.key,
      required this.idTable,
      required this.idShop,
      required this.searchDateTimeString,
      required this.appBar,
      this.reserve});
  final int idTable;
  final int idShop;
  final String searchDateTimeString;
  final PreferredSizeWidget appBar;
  final ReserveEntity? reserve;

  @override
  State<ScreenCreateReserve> createState() => _ScreenCreateReserveState();
}

class _ScreenCreateReserveState extends State<ScreenCreateReserve> {
  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = context.read<ReserveBloc>();
    DateTime searchDateTime = widget.reserve == null ?  DateFormat("dd-MM-yyyy HH:mm").parse(widget.searchDateTimeString):
        DateFormat("dd - MM - yyyy HH:mm").parse(widget.searchDateTimeString);
    return DefaultScaffold(
        appBar: widget.appBar,
        body: BodyCreateReserve(
          idTable: widget.idTable,
          reserveBloc: reserveBloc,
          idShop: widget.idShop,
          searchDateTime: searchDateTime,
          reserve: widget.reserve,
        ));
  }
}
