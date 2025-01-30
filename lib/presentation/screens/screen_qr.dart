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

class QRScannerScreen extends StatefulWidget {
  final int idTable;
  final int idReserve;
  final int idShop;
  const QRScannerScreen(
      {super.key,
      required this.idTable,
      required this.idReserve,
      required this.idShop});

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
                                        if (scannedCode ==
                                            'rollandreserve://app/user/userReserves/${widget.idTable}') {
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
                                            confirmReserveDialog(
                                                context,
                                                "La sesión de juego aún no ha comenzado",
                                                true);
                                          }
                                        } else {
                                          confirmReserveDialog(
                                              context,
                                              "Mesa erronea de la reserva",
                                              true);
                                        }
                                      });
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
                                      if (scannedCode != null)
                                        Text(
                                          'Código escaneado: $scannedCode',
                                          textAlign: TextAlign.center,
                                        ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            scannedCode = null;
                                          });
                                        },
                                        child: const Text('Volver a escanear'),
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
                              child: const Text(
                                  'Otorgar permisos de uso de la cámara'),
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
