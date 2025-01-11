import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_shop.dart';

class BodyMain extends StatefulWidget {
  const BodyMain({
    super.key,
  });

  @override
  State<BodyMain> createState() => _BodyMainState();
}

class _BodyMainState extends State<BodyMain> {
  @override
  void initState() {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
    if (loginBloc.state.user!.role == 2) {
      context.read<ShopBloc>().add(GetShopsEvent());
    } else {
      context
          .read<ShopBloc>()
          .add(GetShopsByOwnerEvent(owner: loginBloc.state.user!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.shops != null) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
                child: loginBloc.state.user!.role == 2
                    ? Column(
                        children: [
                          Text(
                            "Bienvenido ${loginBloc.state.user?.username}!,",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          Text(
                            "Estas son todas las tiendas disponibles.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                        ],
                      )
                    : Text(
                        "Tiendas registradas a tu nombre:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: state.shops!.length,
                itemBuilder: (context, index) {
                  final shop = state.shops![index];
                  return Builder(
                      builder: (context) => GestureDetector(
                          onTap: () {
                            loginBloc.state.user!.role == 1
                                ? context.go('/user/shop_edit/${shop.id}')
                                : context.go('/user/shop/${shop.id}');
                          },
                          child: InformationShop(shop: shop)));
                },
              )),
            ],
          ),
        );
      } else {
        return const Center(child: Text("No tienes tiendas"));
      }
    });
  }
}
