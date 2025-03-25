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
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopLogo(theme, isSmallScreen),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShopHeader(theme, isSmallScreen),
                    const SizedBox(height: 8),
                    _buildShopAddress(theme),
                    const SizedBox(height: 16),
                    _buildShopStats(theme, loc),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButtons(context, theme, loc),
              ],
            ),
          ) 
        ],
      ),
    );
  }

  Widget _buildShopLogo(ThemeData theme, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 100 : 120,
      height: isSmallScreen ? 100 : 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: kIsWeb
            ? _buildWebImage()
            : Image.file(
                File(widget.shop.logo.path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildImageErrorPlaceholder(),
              ),
      ),
    );
  }

  Widget _buildShopHeader(ThemeData theme, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.shop.name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildShopAddress(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 18,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.shop.address,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShopStats(ThemeData theme, AppLocalizations loc) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        buildStars(widget.shop.averageRaiting),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.table_bar, size: 18, color: Colors.grey),
            const SizedBox(width: 6.0),
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
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final isAdmin = context.read<LoginBloc>().state.user!.role == 1;

    return Column(
      children: [
        if (isAdmin) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 1),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildAdminButton(
                icon: Icons.table_restaurant,
                label: loc.edit_shop,
                color: theme.colorScheme.primary,
                route: '/user/shop/${widget.shop.id}',
              ),
              _buildAdminButton(
                icon: Icons.edit_rounded,
                label: loc.edit_info,
                color: theme.colorScheme.error,
                route: '/user/shop_edit/${widget.shop.id}',
              ),
            ],
          ),
        ],
      ],
    );
  }


  Widget _buildAdminButton({
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return FilledButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor:
            color.computeLuminance() > 0.4 ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => context.go(route),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.storefront_rounded,
          size: 40,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildWebImage() {
    if (widget.shop.logo is Uint8List) {
      return Image(
        image: MemoryImage(widget.shop.logo as Uint8List),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImageErrorPlaceholder();
        },
      );
    }
    return _buildImageErrorPlaceholder();
  }
}
