import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScannerScreen extends StatefulWidget {
  final int idTable;
  final int idReserve;
  final int idShop;

  final PreferredSizeWidget appBar;
  const QRScannerScreen(
      {super.key,
      required this.idTable,
      required this.idReserve,
      required this.idShop,
      required this.appBar});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedCode;
  bool cameraPermissionGranted = false;

  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the reserve with users for the
  /// given idReserve from the database and requesting the shop with the given
  /// idShop from the database. It is also responsible for requesting the camera
  /// permission.
  void initState() {
    super.initState();
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    context.read<ShopBloc>().add(GetShopEvent(idShop: widget.idShop));
    _requestCameraPermission();
  }

  /// Requests camera permission from the user.
  ///
  /// This method checks if camera permission has been granted. If granted, it
  /// updates the [cameraPermissionGranted] state to true. If the permission is
  /// permanently denied, it opens the app settings to allow the user to enable
  /// the permission manually.

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      cameraPermissionGranted = status.isGranted;
    });
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
/// Builds the QR scanner screen widget.
///
/// This widget uses a [DefaultScaffold] with a given [appBar].
/// If camera permission is granted, it uses [BlocBuilder]s to
/// manage the state of [ShopBloc] and [ReserveBloc], displaying
/// the QR scanner through [MobileScanner] and processing scanned
/// barcodes. The scanner overlay is also built on top of the scanner.
///
/// If camera permission is not granted, it displays a message
/// prompting the user to grant camera permission, with an option
/// to request the permission again.

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return DefaultScaffold(
      appBar: widget.appBar,
      body: cameraPermissionGranted
          ? BlocBuilder<ShopBloc, ShopState>(
              builder: (context, state) {
                return buildContent<ShopState>(
                  state: state,
                  isLoading: (state) => state.isLoading,
                  errorMessage: (state) => state.errorMessage,
                  hasData: (state) => state.shop != null,
                  context: context,
                  contentBuilder: (state) {
                    return BlocBuilder<ReserveBloc, ReserveState>(
                      builder: (context, state) {
                        return buildContent<ReserveState>(
                          state: state,
                          isLoading: (state) => state.isLoading,
                          errorMessage: (state) => state.errorMessage,
                          hasData: (state) => state.reserve != null,
                          context: context,
                          contentBuilder: (state) {
                            return Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      MobileScanner(
                                        onDetect: (capture) {
                                          final List<Barcode> barcodes =
                                              capture.barcodes;
                                          for (final barcode in barcodes) {
                                            setState(() =>
                                                scannedCode = barcode.rawValue);

                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                      ),
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(24),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            CircularProgressIndicator
                                                                .adaptive(
                                                              strokeWidth: 2,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      colorScheme
                                                                          .primary),
                                                            ),
                                                            const SizedBox(
                                                                height: 24),
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .processing_code,
                                                              style: textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                color: colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));

                                            _handleScannedCode(context, state);
                                          }
                                        },
                                      ),
                                      _buildScannerOverlay(colorScheme),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: FilledButton.icon(
                                        icon: Icon(Icons.camera_alt_rounded,
                                            size: 20,
                                            color: colorScheme.onPrimary),
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .scan_again,
                                          style: textTheme.labelLarge?.copyWith(
                                              color: colorScheme.onPrimary),
                                        ),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        onPressed: () =>
                                            setState(() => scannedCode = null),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_enhance_rounded,
                        size: 64,
                        color: colorScheme.onSurface.withOpacity(0.5)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: Icon(Icons.camera_alt_rounded,
                          color: colorScheme.onPrimary),
                      label: Text(
                        AppLocalizations.of(context)!.grant_camera_permission,
                        style: textTheme.labelLarge
                            ?.copyWith(color: colorScheme.onPrimary),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _requestCameraPermission,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Builds the overlay that appears when scanning a QR code.
  ///
  /// This is a rectangle with a solid border and a centered text that
  /// instructs the user to align the QR code with the rectangle.
  ///
  /// The color scheme is used to determine the color of the border and the
  /// text. The border width is 4 and the border style is solid.
  ///
  /// The text is in the bodyMedium font style with a font size of 16 and
  /// a font weight of 500. The text is centered horizontally and vertically.
  ///
  /// The width and height of the overlay are both 250.
  Widget _buildScannerOverlay(ColorScheme colorScheme) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.primary.withOpacity(0.8),
            width: 4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      width: 250,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.align_qr_code,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the scanned QR code and performs actions based on the code.
  ///
  /// If the scanned QR code matches the expected format for a user reserve,
  /// it checks if the current time is within 5 minutes before the start time
  /// of the reservation. If so, it attempts to confirm the user's location
  /// and proceed with the reservation confirmation process.
  ///
  /// If the code is incorrect or the reservation hasn't started yet,
  /// it shows an appropriate dialog with an error message.
  ///
  /// In case of an error during processing, it displays an error dialog.
  ///
  /// The method ensures that the scanned code is reset if it was invalid or not
  /// the expected code.

  void _handleScannedCode(BuildContext context, ReserveState state) async {
    final loc = AppLocalizations.of(context)!;

    try {
      if (scannedCode ==
          'rollandreserve://app/user/userReserves/${widget.idTable}') {
        final startDate = DateFormat('dd - MM - yyyy HH:mm')
            .parse('${state.reserve!.dayDate} ${state.reserve!.horaInicio}');

        final fiveMinutesBefore =
            startDate.subtract(const Duration(minutes: 5));

        if (fiveMinutesBefore.isBefore(DateTime.now())) {
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
          await checkUserLocation(context, widget.idReserve);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          confirmReserveDialog(
            context,
            loc.game_session_not_started,
            true,
            
          );
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        confirmReserveDialog(
          context,
          loc.wrong_reservation_table,
          true,
      
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (!mounted) return;
      confirmReserveDialog(
        context,
        '${loc.error_processing_code}: ${e.toString()}',
        true,
      );
    } finally {
      if (scannedCode == null ||
          scannedCode !=
              'rollandreserve://app/user/userReserves/${widget.idTable}') {
        setState(() => scannedCode = null);
      }
    }
  }
}
