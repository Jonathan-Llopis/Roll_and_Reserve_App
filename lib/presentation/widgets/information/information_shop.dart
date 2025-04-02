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
  /// Called when the widget is inserted into the tree.
  ///
  /// This function is called when the widget is inserted into the tree.
  void initState() {
    super.initState();
  }

  @override
  /// Builds the UI for the information of the shop.
  ///
  /// This widget is a [Container] with a [BoxDecoration] that has a white
  /// background, a circular border radius, a shadow, and a border.
  ///
  /// The child of the [Container] is a [Column] with two children. The first
  /// child is a [Row] with a [CircleAvatar] with the logo of the shop, and a
  /// [Column] with the name, address, and rating of the shop. The second child
  /// is a [Wrap] with the action buttons of the shop.
  ///
  /// The [CircleAvatar] has a size of 50x50 and a border radius of 50.
  /// The [Column] has a crossAxisAlignment of [CrossAxisAlignment.start].
  /// The [Text] with the name of the shop has a font size of 24 and is bold.
  /// The [Text] with the address of the shop has a font size of 16 and is
  /// grey.
  /// The [Text] with the rating of the shop has a font size of 16 and is
  /// orange.
  /// The [Wrap] has a spacing of 12 and a runSpacing of 12. The children of the
  /// [Wrap] are the action buttons of the shop.
  ///
  /// The action buttons are [ElevatedButton]s with a text and an onPressed
  /// function. The onPressed function navigates to the shop page with the id
  /// of the shop.
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

  /// Builds a widget that displays the logo of the shop.
  ///
  /// The widget is a container with a rounded rectangle shape and a
  /// shadow. The logo is displayed as a [ClipRRect] with a circular
  /// border radius of 20. The logo is either an [Image] or a placeholder
  /// image. If the logo is an image, it is displayed with a BoxFit of cover.
  /// If the logo is a placeholder, it is displayed with a height and width
  /// of 100. The placeholder image is a blue square with a white text
  /// "Error" in the center.
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

  /// Builds a header widget to display the shop's name.
  ///
  /// The header is a [Column] with a [Text] widget showing the shop's name.
  /// The text style is determined by the [theme]'s `titleLarge` text style,
  /// with a bold font weight and the color from the theme's `onSurface` color.
  /// The text is limited to a maximum of two lines and will show an ellipsis
  /// if it overflows.

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

  /// Builds a row widget to display the shop's address.
  ///
  /// The row contains an [Icon] of a location and a [Text] widget
  /// showing the shop's address. The icon is displayed with a size of
  /// 18 and a color of 60% of the theme's `onSurface` color. The text
  /// is displayed with the theme's `bodyMedium` text style and a color
  /// of 70% of the theme's `onSurface` color. The row is aligned to the
  /// start of the cross axis.
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

  /// Builds a row widget to display the shop's statistics.
  ///
  /// The row contains a [Wrap] widget with two children. The first child is
  /// a [Row] that displays the shop's average rating as a row of stars.
  /// The second child is a [Row] that displays the total number of tables
  /// that the shop has. The text is displayed with the theme's `bodyMedium`
  /// text style and a color of 70% of the theme's `onSurface` color. The
  /// row is aligned to the start of the cross axis.
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

  /// Builds action buttons for the shop interface.
  ///
  /// This widget creates a column of action buttons available to admins.
  /// If the current user is an admin or owner, it shows buttons for editing
  /// the shop and its information. Each button is represented as a wrapped
  /// icon and label, styled according to the theme and role.
  ///
  /// The buttons are:
  /// - "Edit Shop": Navigates to the shop's table management page.
  /// - "Edit Info": Navigates to the shop's information editing page.
  ///
  /// [context] is used to read the [LoginBloc] to determine the user's role.
  /// [theme] provides the styling for the buttons.
  /// [loc] is used for localized labels on the buttons.

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, AppLocalizations loc) {
    final isAdmin = context.read<LoginBloc>().state.user!.role == 1 ||
        context.read<LoginBloc>().state.user!.role == 0;

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


  /// Builds an admin action button with an icon and label.
  ///
  /// The button is styled with a background color and adjusts its
  /// foreground color based on the luminance of the background color
  /// to ensure text visibility. It is represented as a [FilledButton]
  /// and navigates to the provided [route] when pressed.
  ///
  /// - [icon]: The icon to display on the button.
  /// - [label]: The text label for the button.
  /// - [color]: The background color of the button.
  /// - [route]: The navigation route to execute on button press.

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

  /// A placeholder widget to display if an image fails to load.
  ///
  /// This widget is used as the error builder for the [Image] widget in
  /// [_buildWebImage] to provide a fallback when the image fails to load.
  /// It displays a light grey background with a grey icon in the center.
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

  /// Builds the shop's logo image for the web.
  ///
  /// If the shop's logo is a [Uint8List], it is displayed as an [Image] widget
  /// with a [MemoryImage] provider. The image is fit to cover the available
  /// space and a [CircularProgressIndicator] is used to display the loading
  /// progress. If the image fails to load, a placeholder widget is displayed
  /// instead.
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
