// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatWorkingHour(
    String dayEn,
    TimeOfDay? start,
    TimeOfDay? end,
    String localeCode,
    BuildContext context,
  ) {
    // Convert TimeOfDay to DateTime today
    DateTime? startDt;
    DateTime? endDt;
    final now = DateTime.now();
    if (start != null)
      startDt = DateTime(
        now.year,
        now.month,
        now.day,
        start.hour,
        start.minute,
      );
    if (end != null)
      endDt = DateTime(now.year, now.month, now.day, end.hour, end.minute);

    final startStr =
        startDt != null ? DateFormat.jm(localeCode).format(startDt) : '';
    final endStr = endDt != null ? DateFormat.jm(localeCode).format(endDt) : '';

    // Translate day name if Arabic
    String day = dayEn;
    if (localeCode == 'ar') {
      final daysAr = {
        'Monday': 'الاثنين',
        'Tuesday': 'الثلاثاء',
        'Wednesday': 'الأربعاء',
        'Thursday': 'الخميس',
        'Friday': 'الجمعة',
        'Saturday': 'السبت',
        'Sunday': 'الأحد',
      };
      day = daysAr[dayEn] ?? dayEn;
    }

    return startStr.isNotEmpty && endStr.isNotEmpty
        ? '$day: $startStr - $endStr'
        : day;
  }
}

class AddressTabView extends StatefulWidget {
  final FoodTruck foodTruck;

  const AddressTabView({super.key, required this.foodTruck});

  @override
  State<AddressTabView> createState() => _AddressTabViewState();
}

class _AddressTabViewState extends State<AddressTabView> {
  late GoogleMapController _mapController;
  BitmapDescriptor? _customIcon;
  double _currentZoom = 14.0;
  final String _uniqueMapId = UniqueKey().toString();
  final String _uniqueMarkerId = UniqueKey().toString();

  Future<void> _launchDirections() async {
    final lat = widget.foodTruck.latitude;
    final lng = widget.foodTruck.longitude;
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  Future<void> _shareLocation() async {
    final lat = widget.foodTruck.latitude;
    final lng = widget.foodTruck.longitude;
    final shareUrl =
        'https://www.google.com/maps?q=$lat,$lng&ll=$lat,$lng&z=14';
    Share.share(
      'check out Nine The 9 Location $shareUrl',
      subject: 'Nine The 9 Location',
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch phone call')));
    }
  }

  Future<void> _openWebsite(String website) async {
    try {
      // Ensure the URL has a proper scheme
      String url = website;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final Uri launchUri = Uri.parse(url);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch website');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open website')));
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentZoom = position.zoom;
    });
  }

  Future<void> _zoomIn() async {
    await _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    await _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List? iconData = await _getBytesFromAsset(
      'assets/icons/truck_ic.png',
      60, // Width in physical pixels
    );

    if (iconData != null) {
      _customIcon = BitmapDescriptor.bytes(iconData);
    }
  }

  Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // Forces exact pixel width
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _customIcon = null; // Clear the custom icon to free resources
    _currentZoom = 14.0; // Reset zoom level
    // Clean up any other resources if necessary
    _uniqueMapId; // Unique key for the map
    _uniqueMarkerId; // Unique key for the marker
    // Note: Unique keys are not disposed, but you can reset them if needed
    // This is just to ensure that the state is clean when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final truckLocation = LatLng(
      widget.foodTruck.latitude,
      widget.foodTruck.longitude,
    );
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).mapLocation,
            style: context.theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.small),
          // Map section with fixed height
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                GoogleMap(
                  key: Key(_uniqueMapId),
                  initialCameraPosition: CameraPosition(
                    target: truckLocation,
                    zoom: _currentZoom,
                  ),
                  markers: {
                    Marker(
                      icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                      markerId: MarkerId(_uniqueMarkerId),
                      position: truckLocation,

                      infoWindow: InfoWindow(
                        title: widget.foodTruck.name,
                        snippet: S.of(context).tapForLocation,
                      ),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoomIn',
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoomOut',
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          // Make the rest scrollable to avoid overflow
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.medium,
                    runSpacing: AppSpacing.small,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _shareLocation,
                        icon: const Icon(Icons.share),
                        label: Text(S.of(context).shareLocation),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _launchDirections,
                        icon: const Icon(Icons.directions),
                        label: Text(S.of(context).getDirection),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    S.of(context).description,
                    style: context.theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    widget.foodTruck.description,
                    style: context.theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  //contact info
                  Text(
                    S.of(context).contactInfo,
                    style: context.theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: context.theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      InkWell(
                        onTap: () => _makePhoneCall(widget.foodTruck.phone),
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.foodTruck.phone),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).phoneCopied)),
                          );
                        },
                        child: Text(
                          widget.foodTruck.phone,
                          style: context.theme.textTheme.bodyMedium!.copyWith(
                            color: context.theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: context.theme.colorScheme.primary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  if (widget.foodTruck.website != null &&
                      widget.foodTruck.website!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.web,
                          color: context.theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: InkWell(
                            onTap:
                                () => _openWebsite(widget.foodTruck.website!),
                            onLongPress: () {
                              Clipboard.setData(
                                ClipboardData(text: widget.foodTruck.website!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Website copied to clipboard'),
                                ),
                              );
                            },
                            child: Text(
                              widget.foodTruck.website!,
                              style: context.theme.textTheme.bodyMedium!
                                  .copyWith(
                                    color: context.theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        context.theme.colorScheme.primary,
                                  ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    S.of(context).workingHour(''),
                    style: context.theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.foodTruck.workingHours!.length,
                    itemBuilder: (context, index) {
                      final wh = widget.foodTruck.workingHours![index];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        style: ListTileStyle.list,
                        leading: Icon(
                          wh.isClosed ? Icons.close : Icons.access_time,
                          color:
                              wh.isClosed
                                  ? Colors.red
                                  : context.theme.colorScheme.success,
                        ),
                        title: Text(
                          wh.isClosed
                              ? DateTimeUtils.formatWorkingHour(
                                wh.day,
                                null,
                                null,
                                localeCode,
                                context,
                              )
                              : DateTimeUtils.formatWorkingHour(
                                wh.day,
                                wh.openingTime,
                                wh.closingTime,
                                localeCode,
                                context,
                              ),
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
