import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyMain extends StatefulWidget {
  const BodyMain({
    super.key,
  });

  @override
  State<BodyMain> createState() => _BodyMainState();
}

class _BodyMainState extends State<BodyMain> {
  @override
/// Builds the widget tree for displaying the list of shops.
///
/// This method uses a [BlocBuilder] to rebuild the UI based on the state of
/// the [ShopBloc]. It displays a loading indicator if the state is loading,
/// an error message if there is an error, or a list of shops if the data is
/// available.
///
/// The widget tree includes a welcome message for the user, a description
/// of the available shops, and a list of [InformationShop] widgets. Each
/// shop in the list is wrapped in a [GestureDetector] to navigate to the
/// shop's details when tapped, unless the user is an admin.

  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      return buildContent<ShopState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.shops != null,
          context: context,
          contentBuilder: (state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.welcome_user(loginBloc
                                        .state.user!.username.length >
                                    15
                                ? '${loginBloc.state.user!.username.substring(0, 15)}...'
                                : loginBloc.state.user!.username),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.all_available_shops,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Expanded(
                    child: ListView.builder(
                  itemCount: state.shops!.length,
                  itemBuilder: (context, index) {
                    final shop = state.shops![index];
                    return Builder(
                        builder: (context) => GestureDetector(
                            onTap: () {
                              loginBloc.state.user!.role == 1
                                  ? null
                                  : context.go('/user/shop/${shop.id}');
                            },
                            child: InformationShop(shop: shop)));
                  },
                )),
              ],
            );
          });
    });
  }
}
