import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_tables.dart';

class BottomFilterTables extends StatelessWidget {
  const BottomFilterTables({
    required this.currentShop,
    super.key,
  });
  final ShopEntity currentShop;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.delete_outline),
          label: 'Remove Filters',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.filter_list),
          label: ' Filtrar Mesas Libres',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          context.read<TableBloc>().add(GetTablesByShopEvent(idShop: currentShop.id,
               ));
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterTables(currentShop: currentShop);
            },
          );
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
