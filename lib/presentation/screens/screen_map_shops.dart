import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/map_marker.dart';

class StoreMap extends StatefulWidget {
  const StoreMap({super.key});

  @override
  State<StoreMap> createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  coordinates.LatLng? _currentLocation;
  late double currentZoomLevel;
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();

  @override
  void initState() {
    context.read<ShopBloc>().add(GetShopsEvent());
    currentZoomLevel = 12;
    super.initState();
  }

  Future<void> _getCurrentLocation(bool userLocation) async {
    bool serviceEnabled;
    LocationPermission permission;

    if (_currentLocation != null && userLocation == false) {
      return;
    }

    if (latitudeController.text != "0" &&
        longitudeController.text != "0" &&
        latitudeController.text.isNotEmpty &&
        longitudeController.text.isNotEmpty) {
      _currentLocation = coordinates.LatLng(
          double.parse(latitudeController.text),
          double.parse(longitudeController.text));
    }

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no se puede continuar
      return Future.error(
          AppLocalizations.of(context)!.location_service_disabled);
    }

    // Verificar los permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no se puede continuar
        return Future.error(
            AppLocalizations.of(context)!.location_permission_denied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente, no se puede continuar
      return Future.error(
          AppLocalizations.of(context)!.location_permission_denied_permanently);
    }

    // Obtener la posición actual del usuario
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _currentLocation =
        coordinates.LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return FutureBuilder(
        future: _getCurrentLocation(false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Card(
                color: Colors.redAccent.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!
                        .error_snapshot(snapshot.error.toString()),
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            return BlocBuilder<ShopBloc, ShopState>(
              builder: (context, state) {
                return buildContent<ShopState>(
                  state: state,
                  isLoading: (state) => state.isLoading,
                  errorMessage: (state) => state.errorMessage,
                  hasData: (state) => state.shops != null,
                  context: context,
                  contentBuilder: (state) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Tiendas cercanas'),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      body: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialZoom: currentZoomLevel,
                              initialCenter: coordinates.LatLng(
                                _currentLocation!.latitude,
                                _currentLocation!.longitude,
                              ),
                              interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.drag |
                                    InteractiveFlag.pinchZoom |
                                    InteractiveFlag.doubleTapZoom,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              ),
                              MarkerLayer(
                                markers: state.shops!
                                    .map(
                                      (store) => Marker(
                                        width: 40.0,
                                        height: 40.0,
                                        point: coordinates.LatLng(
                                            store.latitude, store.longitude),
                                        child: MapMarker(loginBloc: loginBloc, store: store),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  heroTag: "zoomIn",
                                  onPressed: () {
                                    setState(() {
                                      currentZoomLevel += 1;
                                    });
                                  },
                                  child: const Icon(Icons.zoom_in),
                                ),
                                const SizedBox(height: 10),
                                FloatingActionButton(
                                  heroTag: "zoomOut",
                                  onPressed: () {
                                    setState(() {
                                      currentZoomLevel -= 1;
                                    });
                                  },
                                  child: const Icon(Icons.zoom_out),
                                ),
                                const SizedBox(height: 10),
                                FloatingActionButton(
                                  heroTag: "centerLocation",
                                  onPressed: () {
                                    _getCurrentLocation(
                                      true,
                                    ).then((_) {
                                      setState(() {
                                        _currentLocation = _currentLocation;
                                      });
                                    });
                                  },
                                  child: const Icon(Icons.my_location),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        });
  }
}
