import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationShop extends StatefulWidget {
  const InformationShop({
    super.key,
    required this.shop,
  });

  final ShopEntity shop;

  @override
  State<InformationShop> createState() => _ShopListInventoryState();
}

class _ShopListInventoryState extends State<InformationShop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: kIsWeb
                      ? (widget.shop.logo is Uint8List
                          ? Image(
                              image: MemoryImage(widget.shop.logo),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Image(
                                    image: AssetImage(
                                        'assets/images/error-image.png'));
                              },
                            )
                          : const Icon(Icons.shop, color: Colors.white54))
                      : Image(
                          image: FileImage(File(widget.shop.logo.path)),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Image(
                                image: AssetImage(
                                    'assets/images/error-image.png'));
                          },
                        ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_bar, size: 16, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(
                    AppLocalizations.of(context)!
                        .total_tables(widget.shop.tablesShop.length),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              buildStars(widget.shop.averageRaiting),
            ],
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shop.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.shop.address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                loginBloc.state.user!.role == 1
                    ? ElevatedButton(
                        onPressed: () {
                          context.go('/user/shop/${widget.shop.id}');
                        },
                        child: Text(AppLocalizations.of(context)!.edit_table),
                      )
                    : Container(),
              ],
            ),
          ),
          loginBloc.state.user!.role == 1
              ? IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    context.go('/user/shop_edit/${widget.shop.id}');
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
