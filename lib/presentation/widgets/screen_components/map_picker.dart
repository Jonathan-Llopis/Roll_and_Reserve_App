import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPicker extends StatefulWidget {
  final double zoomLevel;
  final bool displayOnly;
  final Color markerColor;
  final TextEditingController longitudeController;
  final TextEditingController latitudeController;

  const LocationPicker({
    super.key,
    this.zoomLevel = 12.0,
    this.displayOnly = false,
    this.markerColor = Colors.redAccent,
    required this.longitudeController,
    required this.latitudeController,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  coordinates.LatLng? _currentLocation;
  late double currentZoomLevel;

  @override
  /// Initializes the state of the widget.
  ///
  /// It calls the [State.initState] method of the parent class.
  ///
  /// This method is called when the widget is inserted into the tree.
  void initState() {
    super.initState();
    currentZoomLevel = widget.zoomLevel;
  }

  /// Gets the current location of the user.
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

    if (widget.latitudeController.text != "0" &&
        widget.longitudeController.text != "0") {
      _currentLocation = coordinates.LatLng(
          double.parse(widget.latitudeController.text),
          double.parse(widget.longitudeController.text));
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
/// Builds a widget to display a map for picking a location.
///
/// The widget uses a [FutureBuilder] to handle the asynchronous process of
/// obtaining the user's current location. While waiting for the location,
/// a [CircularProgressIndicator] is shown. If an error occurs during this process,
/// an error message is displayed.
///
/// Once the location is obtained, a [FlutterMap] widget is displayed, allowing
/// the user to select a location on the map. The selected location's coordinates
/// are updated in the [longitudeController] and [latitudeController].
///
/// The map includes zoom controls and a button to center on the user's current
/// location, unless the [displayOnly] flag is set to true, in which case these
/// controls are hidden.

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return FutureBuilder(
      future: _getCurrentLocation(false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!
                    .error_snapshot(snapshot.error.toString()),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Actualizar coordenadas si es necesario
        if (widget.latitudeController.text == "0" &&
            widget.longitudeController.text == "0") {
          widget.latitudeController.text =
              _currentLocation!.latitude.toString();
          widget.longitudeController.text =
              _currentLocation!.longitude.toString();
        }

        return Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      child: Text(
                        AppLocalizations.of(context)!
                            .select_your_location_on_map,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth * 0.6,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          options: MapOptions(
                            initialZoom: currentZoomLevel,
                            initialCenter: coordinates.LatLng(
                              double.parse(widget.latitudeController.text),
                              double.parse(widget.longitudeController.text),
                            ),
                            onTap: widget.displayOnly
                                ? null
                                : (tapPosition, point) {
                                    setState(() {
                                      _currentLocation = point;
                                      widget.latitudeController.text =
                                          point.latitude.toString();
                                      widget.longitudeController.text =
                                          point.longitude.toString();
                                    });
                                  },
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
                              userAgentPackageName: 'com.example.app',
                              retinaMode: true,
                            ),
                            MarkerLayer(
                              markers: _currentLocation != null
                                  ? [
                                      Marker(
                                        width: 48.0,
                                        height: 48.0,
                                        point: coordinates.LatLng(
                                          double.parse(
                                              widget.latitudeController.text),
                                          double.parse(
                                              widget.longitudeController.text),
                                        ),
                                        child: Icon(
                                          Icons.location_pin,
                                          color: colorScheme.error,
                                          size: 40.0,
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (!widget.displayOnly)
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: "zoomIn",
                      onPressed: () => setState(() => currentZoomLevel += 1),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: "zoomOut",
                      onPressed: () => setState(() => currentZoomLevel -= 1),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: "centerLocation",
                      onPressed: () => _getCurrentLocation(true).then((_) {
                        setState(() {
                          _currentLocation = _currentLocation;
                          widget.latitudeController.text =
                              _currentLocation!.latitude.toString();
                          widget.longitudeController.text =
                              _currentLocation!.longitude.toString();
                        });
                      }),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Icon(Icons.my_location, size: 20),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
