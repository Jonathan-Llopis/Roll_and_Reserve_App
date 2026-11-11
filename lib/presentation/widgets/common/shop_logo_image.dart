import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopLogoImage extends StatelessWidget {
  final ShopEntity shop;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ShopLogoImage({
    super.key,
    required this.shop,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  Widget _buildDefaultError() {
    return errorWidget ??
        Image.asset(
          'assets/images/error-image.png',
          width: width,
          height: height,
          fit: fit,
        );
  }

  Widget _buildDefaultPlaceholder() {
    return placeholder ??
        SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // 1. In-memory bytes (web uploads or previews)
    if (shop.logo is Uint8List) {
      return Image.memory(
        shop.logo as Uint8List,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildDefaultError(),
      );
    }

    // 2. Local file on device
    if (shop.logo is File) {
      final file = shop.logo as File;
      if (file.path.isNotEmpty && !kIsWeb) {
        try {
          if (file.existsSync()) {
            return Image.file(
              file,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, __, ___) => _buildDefaultError(),
            );
          }
        } catch (_) {}
      }
    }

    // 3. Remote URL with CachedNetworkImage
    final logoUrl = shop.logoUrl;
    if (logoUrl.isNotEmpty) {
      String? token;
      try {
        if (GetIt.instance.isRegistered<SharedPreferences>()) {
          token = GetIt.instance<SharedPreferences>().getString('token');
        }
      } catch (_) {}

      return CachedNetworkImage(
        imageUrl: logoUrl,
        httpHeaders: token != null ? {'Authorization': 'Bearer $token'} : null,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _buildDefaultPlaceholder(),
        errorWidget: (_, __, ___) => _buildDefaultError(),
      );
    }

    // 4. Default fallback
    return _buildDefaultError();
  }
}
