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
import 'package:roll_and_reserve/presentation/widgets/screen_components/map_control_button.dart';
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
  bool _isUpdatingLocation = false;

  @override
  /// Initialize the state of the store map widget.
  ///
  /// This function is called when the widget is inserted into the tree.
  /// It triggers the fetching of shops data by dispatching a `GetShopsEvent`
  /// to the `ShopBloc` and sets the initial zoom level for the map.

  void initState() {
    context.read<ShopBloc>().add(GetShopsEvent());
    currentZoomLevel = 10;
    super.initState();
  }
  /// Gets the current location of the user.
  ///
  /// This function is used to get the user's current location.
  /// It can be used to either get the user's location using the device's GPS
  /// or to set the location to a predefined value.
  ///
  /// The [userLocation] parameter indicates if the user's location should be
  /// obtained from the device's GPS or if it should be set to a predefined value.
  /// If the value is true, the user's location is obtained from the device's GPS.
  /// If the value is false, the user's location is set to the value of the
  /// [latitudeController] and [longitudeController] controllers.
  ///
  /// The function returns a Future that completes when the user's location has
  /// been obtained.
  ///
  /// If the user's location is not available, or if the user has denied the
  /// permission to access the location, the Future completes with an error.
  ///
  /// The function is used to initialize the map with the user's current location
  /// and to update the map when the user's location changes.
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
  /// Builds the screen with the nearby shops.
  ///
  /// The screen is a [Scaffold] with an [AppBar] and a [FlutterMap] as the body.
  /// The [AppBar] has a title with the text "Tiendas cercanas" and a leading
  /// button to go back to the previous page.
  /// The [FlutterMap] shows a map with the user's current location and the
  /// nearby shops. The shops are shown as markers on the map with a
  /// [MapMarker] widget. The user can zoom in and out of the map by tapping
  /// the zoom in and out buttons on the bottom right of the screen.
  /// The user can also tap the my location button to update their location
  /// and show their current location on the map.
  ///
  /// If the user's location is not available, the screen shows an error message.
  /// If the user has denied the permission to access the location, the screen
  /// shows an error message with a retry button.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    
    return FutureBuilder(
      future: _getCurrentLocation(false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.locating_you,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              color: colors.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off_rounded,
                      size: 40,
                      color: colors.onErrorContainer,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!
                          .error_snapshot(snapshot.error.toString()),
                      style: TextStyle(
                        color: colors.onErrorContainer,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context.read<ShopBloc>().add(GetShopsEvent()),
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.nearby_shops),
                          Text(
                            AppLocalizations.of(context)!.tap_marker_info,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface.withOpacity(0.6),
                          ),
                      )],
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      centerTitle: false,
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
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.drag |
                                  InteractiveFlag.pinchZoom |
                                  InteractiveFlag.doubleTapZoom,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.roll_and_reserve',
                            ),
                            MarkerLayer(
                              markers: state.shops!
                                  .map(
                                    (store) => Marker(
                                      width: 50.0,
                                      height: 50.0,
                                      point: coordinates.LatLng(
                                          store.latitude, store.longitude),
                                      child: MapMarker(store: store, loginBloc: loginBloc),
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
                              MapControlButton(
                                icon: Icons.zoom_in_rounded,
                                onPressed: () => setState(() => currentZoomLevel += 1),
                                color: colors.primary,
                              ),
                              const SizedBox(height: 12),
                              MapControlButton(
                                icon: Icons.zoom_out_rounded,
                                onPressed: () => setState(() => currentZoomLevel -= 1),
                                color: colors.primary,
                              ),
                              const SizedBox(height: 12),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: _isUpdatingLocation ? null : 0,
                                    strokeWidth: 2,
                                    color: colors.primary,
                                  ),
                                  MapControlButton(
                                    icon: Icons.my_location_rounded,
                                    onPressed: () {
                                      setState(() => _isUpdatingLocation = true);
                                      _getCurrentLocation(true).then((_) {
                                        setState(() => _isUpdatingLocation = false);
                                      });
                                    },
                                    color: colors.tertiary,
                                  ),
                                ],
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
      },
    );
  }
}

