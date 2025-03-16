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
  void initState() {
    super.initState();
    currentZoomLevel = widget.zoomLevel;
  }

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
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .select_your_location_on_map,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: FlutterMap(
                            options: MapOptions(
                              initialZoom: currentZoomLevel,
                              initialCenter: coordinates.LatLng(
                                  double.parse(widget.latitudeController.text),
                                  double.parse(
                                      widget.longitudeController.text)),
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
                              interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.drag |
                                    InteractiveFlag.pinchZoom |
                                    InteractiveFlag.doubleTapZoom,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: _currentLocation != null
                                    ? [
                                        Marker(
                                          width: 80.0,
                                          height: 80.0,
                                          point: coordinates.LatLng(
                                              double.parse(widget
                                                  .latitudeController.text),
                                              double.parse(widget
                                                  .longitudeController.text)),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.redAccent,
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
                          _getCurrentLocation(true).then((_) {
                            setState(() {
                              _currentLocation = _currentLocation;
                              widget.latitudeController.text =
                                  _currentLocation!.latitude.toString();
                              widget.longitudeController.text =
                                  _currentLocation!.longitude.toString();
                            });
                          });
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
