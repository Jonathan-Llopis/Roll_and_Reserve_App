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
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
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
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_bar, size: 18, color: Colors.grey),
                  const SizedBox(width: 6.0),
                  Text(
                    AppLocalizations.of(context)!
                        .total_tables(widget.shop.tablesShop.length),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              buildStars(widget.shop.averageRaiting),
            ],
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shop.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  widget.shop.address,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      loginBloc.state.user!.role == 1
                          ? ElevatedButton(
                              onPressed: () {
                                context.go('/user/shop/${widget.shop.id}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text(
                                  AppLocalizations.of(context)!.edit_table),
                            )
                          : Container(),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/user/events/${widget.shop.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text("Eventos"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          loginBloc.state.user!.role == 1
              ? IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
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
