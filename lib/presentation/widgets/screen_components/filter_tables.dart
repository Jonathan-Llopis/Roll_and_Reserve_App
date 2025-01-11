import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';

class FilterTables extends StatefulWidget {
  const FilterTables({super.key, required this.currentShop});
  final ShopEntity currentShop;

  @override
  State<FilterTables> createState() => _FilterTablesState();
}

class _FilterTablesState extends State<FilterTables> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReserveBloc, ReserveState>(
      listener: (context, state) {
        if (state.reserves != null) {
          context.read<TableBloc>().add(GetAvailableTablesEvent(
              dayDate: _dateController.text,
              startTime: _startTimeController.text,
              endTime: _endTimeController.text,
              reserves: state.reserves!));
          Navigator.of(context).pop();
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar reservas')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  selectDate(context, _dateController);
                },
                validator: basicValidation,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Hora de inicio',
                  border: OutlineInputBorder(),
                ),
                validator: validateHour,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'Hora de fin',
                  border: OutlineInputBorder(),
                ),
                validator: validateHour,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ReserveBloc>().add(GetReservesByShopEvent(
                          currentShop: widget.currentShop,
                          dateReserve: _dateController.text,
                          startTime: _startTimeController.text,
                          endTime: _endTimeController.text,
                        ));
                  }
                },
                child: const Text('Filtrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
