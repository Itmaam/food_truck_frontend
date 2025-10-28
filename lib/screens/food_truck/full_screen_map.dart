// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMap extends StatefulWidget {
  final LatLng initialLocation;

  const FullScreenMap({super.key, required this.initialLocation});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late LatLng _location;
  String _mapStyle = '';

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_json/map_style_icon.json');
  }

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
    _location = widget.initialLocation;
  }

  void _onMapCreated(GoogleMapController controller) {}

  void _onTap(LatLng pos) {
    setState(() {
      _location = pos;
    });
  }

  void _onConfirm() {
    Navigator.pop(context, _location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectLocation),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _onConfirm)],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _location, zoom: 15),
        markers: {
          Marker(
            markerId: const MarkerId('selected'),
            position: _location,
            draggable: true,
            onDragEnd: (pos) => setState(() => _location = pos),
          ),
        },

        style: _mapStyle,
        onMapCreated: _onMapCreated,
        onTap: _onTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(context.theme.colorScheme.success)),
        onPressed: _onConfirm,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: AppSpacing.medium),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.check), const SizedBox(width: AppSpacing.small), Text(S.of(context).confirm)],
          ),
        ),
      ),
    );
  }
}
