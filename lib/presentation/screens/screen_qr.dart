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
  void initState() {
    super.initState();
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    context.read<ShopBloc>().add(GetShopEvent(idShop: widget.idShop));
    _requestCameraPermission();
  }

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
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      return buildContent<ShopState>(
        state: state,
        isLoading: (state) => state.isLoading,
        errorMessage: (state) => state.errorMessage,
        hasData: (state) => state.shop != null,
        contentBuilder: (state) {
          return BlocBuilder<ReserveBloc, ReserveState>(
            builder: (context, state) {
              return buildContent<ReserveState>(
                state: state,
                isLoading: (state) => state.isLoading,
                errorMessage: (state) => state.errorMessage,
                hasData: (state) => state.reserve != null,
                contentBuilder: (state) {
                  return DefaultScaffold(
                    appBar: widget.appBar,
                    body: cameraPermissionGranted
                        ? Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: MobileScanner(
                                  onDetect: (capture) {
                                    final List<Barcode> barcodes =
                                        capture.barcodes;
                                    for (final barcode in barcodes) {
                                      setState(() {
                                        scannedCode = barcode.rawValue;
                                      });

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );

                                      if (scannedCode ==
                                          'rollandreserve://app/user/userReserves') {
                                        final startDate = DateFormat(
                                                'dd - MM - yyyy HH:mm')
                                            .parse(
                                                '${state.reserve!.dayDate} ${state.reserve!.horaInicio}');
                                        if (startDate
                                            .subtract(Duration(minutes: 5))
                                            .isBefore(DateTime.now())) {
                                          checkUserLocation(
                                              context, widget.idReserve);
                                        } else {
                                          Navigator.of(context).pop();
                                          confirmReserveDialog(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .game_session_not_started,
                                              true);
                                        }
                                      } else {
                                        Navigator.of(context).pop();
                                        confirmReserveDialog(
                                            context,
                                            AppLocalizations.of(context)!
                                                .wrong_reservation_table,
                                            true);
                                      }
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            scannedCode = null;
                                          });
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .scan_again),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: ElevatedButton(
                              onPressed: _requestCameraPermission,
                              child: Text(AppLocalizations.of(context)!
                                  .grant_camera_permission),
                            ),
                          ),
                  );
                },
              );
            },
          );
        },
      );
    });
  }
}
