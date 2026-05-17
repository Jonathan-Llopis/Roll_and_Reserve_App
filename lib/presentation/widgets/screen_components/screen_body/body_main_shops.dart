import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_shop.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';

class BodyMain extends StatefulWidget {
  const BodyMain({
    super.key,
  });

  @override
  State<BodyMain> createState() => _BodyMainState();
}

class _BodyMainState extends State<BodyMain> {
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);

    if (shopBloc.state.shops == null) {
      if (loginBloc.state.user!.role == 2 || loginBloc.state.user!.role == 0) {
        context.read<ShopBloc>().add(GetShopsEvent());
      } else {
        context
            .read<ShopBloc>()
            .add(GetShopsByOwnerEvent(owner: loginBloc.state.user!.id));
      }
    }

    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        return buildContent<ShopState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.shops != null,
          context: context,
          contentBuilder: (state) {
            return Column(
              children: <Widget>[
                _ShopHeader(user: loginBloc.state.user!),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: _ShopList(
                    shops: state.shops!,
                    userRole: loginBloc.state.user!.role,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ShopHeader extends StatelessWidget {
  final dynamic user;
  const _ShopHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          user.role == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcome_user(
                        user.username.length > 15
                            ? '${user.username.substring(0, 15)}...'
                            : user.username,
                      ),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.all_available_shops,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              : Text(
                  user.role == 1
                      ? l10n.shops_registered_in_your_name
                      : l10n.all_shops,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
        ],
      ),
    );
  }
}

class _ShopList extends StatefulWidget {
  final List<ShopEntity> shops;
  final int userRole;
  const _ShopList({required this.shops, required this.userRole});

  @override
  State<_ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<_ShopList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // TODO: Implement lazy loading trigger here
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.shops.length,
      itemBuilder: (context, index) {
        final shop = widget.shops[index];
        return GestureDetector(
          onTap: () {
            if (widget.userRole != 1) {
              context.go('/user/shop/${shop.id}');
            }
          },
          child: InformationShop(shop: shop),
        );
      },
    );
  }
}
