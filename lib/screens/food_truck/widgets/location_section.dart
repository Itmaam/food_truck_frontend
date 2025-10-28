// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/full_screen_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationSection extends StatefulWidget {
  final LatLng? initialLocation;
  final ValueChanged<LatLng> onLocationChanged;

  const LocationSection({super.key, this.initialLocation, required this.onLocationChanged});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  late LatLng _selectedLocation;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  String? _error;
  String _mapStyle = '';

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_json/map_style_icon.json');
  }

  Future<void> _initializeMap() async {
    try {
      await _loadMapStyle();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _selectedLocation = widget.initialLocation ?? const LatLng(0, 0);
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = S.of(context).locationServicesDisabled.toString();
          _isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = S.of(context).locationPermissionsDenied.toString();
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = S.of(context).locationPermissionsPermanentlyDenied.toString();
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _moveToCurrentLocation();
      widget.onLocationChanged(_selectedLocation);
    } catch (e) {
      setState(() {
        _error = S.of(context).couldNotGetLocation(S.of(context).failedToLoad).toString();
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.setMapStyle(_mapStyle);
  }

  void _updateLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    widget.onLocationChanged(position);
  }

  Future<void> _moveToCurrentLocation() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation, 15));
    }
  }

  Future<void> _refreshLocation() async {
    setState(() => _isLoading = true);
    await _determinePosition();
  }

  Future<void> _zoomIn() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  Future<void> _zoomOut() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.zoomOut());
    }
  }

  Future<void> _fullScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenMap(initialLocation: _selectedLocation)),
    );
    if (result != null && result is LatLng) {
      _updateLocation(result);
      _moveToCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.locationTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red))
        else
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: _selectedLocation, zoom: 15),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  onCameraMove: (position) {
                    _selectedLocation = position.target;
                  },
                  onCameraIdle: () {
                    widget.onLocationChanged(_selectedLocation);
                  },
                ),

                // Fixed center pin
                const Center(child: Icon(Icons.location_pin, size: 50, color: Colors.red)),

                // Custom zoom + full screen controls
                Positioned(
                  right: 16,
                  top: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        mini: true,
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 4),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        mini: true,
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(height: 4),
                      FloatingActionButton(
                        heroTag: 'full-screen',
                        mini: true,
                        onPressed: _fullScreen,
                        child: const Icon(Icons.fullscreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fullScreen,
              icon: const Icon(Icons.fullscreen),
              label: Text(lang.fullScreen),
            ),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _refreshLocation,
              icon: const Icon(Icons.my_location),
              label: Text(lang.currentLocationButton),
            ),
          ],
        ),
      ],
    );
  }
}
