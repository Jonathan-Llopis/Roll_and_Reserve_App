
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_shop_map.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({
    super.key,
    required this.loginBloc,
    required this.store,
  });

  final LoginBloc loginBloc;
  final ShopEntity store;

  @override
  /// Builds a [GestureDetector] that shows a [CardShopMap] when tapped.
  ///
  /// The [GestureDetector] child is a [Container] with a white background, a
  /// rounded border, and a shadow. The [Container] also has a border of width
  /// 2 and color black. The [Container] contains either a [ClipOval] with an
  /// [Image] or an [Icon].
  ///
  /// If the shop's logo is not null and is a [Uint8List], the [ClipOval] contains
  /// an [Image] with the logo. If the shop's logo is null or is not a [Uint8List],
  /// the [ClipOval] contains an [Icon] with the [Icons.shop] icon.
  ///
  /// If the shop's logo is not null and is a [File], the [ClipOval] contains an
  /// [Image] with the logo. If the shop's logo is null or is not a [File], the
  /// [ClipOval] contains an [Icon] with the [Icons.shop] icon.
  ///
  /// If the shop's logo is not null and is not a [Uint8List] or a [File], the
  /// [ClipOval] contains an [SvgPicture] with a blue color if the shop's owner
  /// is the same as the user, and red otherwise.
  ///
  /// When the [GestureDetector] is tapped, it shows a [CardShopMap] with the
  /// shop's details.
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => CardShopMap(
            store: store,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: store.logoId != "67c4bf45ae01906bd75ace8f"
            ? kIsWeb
                ? (store.logo is Uint8List
                    ? ClipOval(
                      child: Image(
                        image: MemoryImage(
                          store.logo),
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                        errorBuilder:
                          (context,
                            error,
                            stackTrace) {
                        return const Image(
                          image: AssetImage(
                            'assets/images/error-image.png'));
                        },
                      ),
                      )
                    : const Icon(Icons.shop,
                        color:
                            Colors.white54))
                : ClipOval(
                  child: Image(
                    image: FileImage(File(
                      store.logo.path)),
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    errorBuilder: (context,
                      error, stackTrace) {
                    return const Image(
                      image: AssetImage(
                        'assets/images/error-image.png'));
                    },
                  ),
                  )
            : SvgPicture.asset(
                'assets/images/dice.svg',
                colorFilter:
                    ColorFilter.mode(
                  store.ownerId ==
                          loginBloc.state
                              .user!.id
                      ? Colors.blue
                      : Colors.redAccent,
                  BlendMode.srcIn,
                ),
                width: 15.0,
                height: 15.0,
              ),
      ),
    );
  }
}
