import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';

class CardShopMap extends StatelessWidget {
  const CardShopMap({super.key, required this.store});

  final ShopEntity store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? (store.logo is Uint8List
                        ? Image(
                            image: MemoryImage(store.logo),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Image(
                                  image: AssetImage(
                                      'assets/images/error-image.png'));
                            },
                          )
                        : const Icon(Icons.shop, color: Colors.white54))
                    : Image(
                        image: FileImage(File(store.logo.path)),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                              image:
                                  AssetImage('assets/images/error-image.png'));
                        },
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.rating}: ",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        buildStars(store.averageRaiting),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      store.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.go('/user/shop/${store.id}');
              },
              child: Text("Ir a la tienda"),
            ),
          ),
        ],
      ),
    );
  }
}
