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
  /// Builds a widget that shows a shop as a card with a logo, name, address,
  /// rating, and a button to go to the shop.
  ///
  /// The logo is shown as a [ClipRRect] with a circular border radius of 8.
  /// The name of the shop is shown as a [Text] with a bold font size of 22.
  /// The address of the shop is shown as a [Text] with a font size of 14 and
  /// a grey color.
  /// The rating of the shop is shown as a [Row] with a [Text] with a font size
  /// of 14 and a [buildStars] with the average rating of the shop.
  /// The button to go to the shop is shown as an [ElevatedButton] with a text
  /// "Ir a la tienda" and an onPressed function that navigates to the shop
  /// page with the id of the shop.
  ///
  /// The widget is wrapped in a [Padding] with a padding of 16.0 on all sides.
  /// The content of the widget is aligned to the start of the column.
  /// The widget is wrapped in a [Column] with a mainAxisSize of min and
  /// a crossAxisAlignment of start.
  /// The widget is wrapped in a [Row] with the logo and the column of text.
  /// The widget is wrapped in a [Center] with a button to go to the shop.
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
              child: Text(AppLocalizations.of(context)!.go_to_shop),
            ),
          ),
        ],
      ),
    );
  }
}
