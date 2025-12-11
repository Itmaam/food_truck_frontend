// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/core/http_client.dart';
import 'package:food_truck_finder_user_app/api/models/category.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/screens/home/widgets/category_selector.dart';
import 'package:food_truck_finder_user_app/screens/home/widgets/popup_window.dart';
import 'package:food_truck_finder_user_app/screens/home/widgets/profile_menu.dart';
import 'package:food_truck_finder_user_app/screens/home/widgets/sub_category_selector.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final UniqueKey _profileKey = UniqueKey();
  final UniqueKey _mapKey = UniqueKey();
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(24.7136, 46.6753); // Default to Riyadh
  BitmapDescriptor? _customIcon;
  String _lightMapStyle = '';
  String _darkMapStyle = '';
  bool _isLoading = true;
  String? _locationError;

  final List<Map<dynamic, dynamic>> _customMarkers = [];

  // Map state
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  CameraPosition? _lastCameraPosition;

  // Debounce timer for map movements
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 800);

  // Categories
  List<int> _selectedCategories = [];
  List<int> _selectedSubCategories = [];
  List<Category> _allCategories = [];
  List<SubCategory> _allSubCategories = [];

  List<dynamic> _allTypes = [];
  List<int> _selectedTypes = [];

  final TextEditingController _searchController = TextEditingController();
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  // Store food trucks for search functionality
  List<FoodTruck> _allFoodTrucks = [];

  // Track current theme brightness to detect changes
  Brightness? _currentBrightness;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newBrightness = Theme.of(context).brightness;

    // Check if theme brightness has changed and map controller is available
    if (_currentBrightness != null && _currentBrightness != newBrightness && _mapController != null) {
      _updateMapStyle();
    }

    _currentBrightness = newBrightness;
  }

  Future<void> _initializeApp() async {
    // Show the map immediately with default location
    setState(() => _isLoading = false);

    // Load extras in parallel (don’t block UI)
    Future.wait([_loadMapStyle(), _loadCustomMarker(), _fetchCategories()]);

    // Try location fetch in background
    _getCurrentLocation();
  }

  Future<void> _loadMapStyle() async {
    _lightMapStyle = await rootBundle.loadString('assets/map_json/map_style_icon.json');
    _darkMapStyle = await rootBundle.loadString('assets/map_json/dark_map_style.json');
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List? iconData = await _getBytesFromAsset(
      'assets/icons/truck_ic.png',
      100, // Width in physical pixels
    );

    if (iconData != null) {
      _customIcon = BitmapDescriptor.fromBytes(iconData);
    }
    HttpClient httpClient = HttpClient();
    try {
      final response = await httpClient.get('${AppUrl.apiUrl}/restaurant-types');
      setState(() {
        // _allTypes = response;
      });
      for (var type in response) {
        final Uint8List? iconData =
            type['image'] != null
                ? await _getBytesFromNetworkImage(type['image'], 100)
                : await _getBytesFromAsset('assets/icons/truck_ic.png', 100);
        if (iconData != null) {
          _customMarkers.add({'id': type['id'], 'name': type['name'], 'icon': BitmapDescriptor.fromBytes(iconData)});
        }
      }
    } catch (e) {
      //print(s);
      debugPrint('Error loading restaurant types: $e');
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

  //get bytes from network image
  Future<Uint8List?> _getBytesFromNetworkImage(String url, int width) async {
    try {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          debugPrint('Failed to load image from network: ${response.statusCode}');
          return null;
        }
        debugPrint('Image loaded from network: ${response.contentLength} bytes');
        // Debugging output to check the response
        if (response.contentLength == null || response.contentLength! <= 0) {
          debugPrint('Image response is empty or invalid');
          return null;
        }
        // Uncomment the line below to see the raw response bytes
        // debugPrint('Raw image response: ${response.bodyBytes}');
        // For debugging purposes, you can print the response length

        final Uint8List bytes = response.bodyBytes;
        final codec = await instantiateImageCodec(
          bytes,
          targetWidth: width, // Forces exact pixel width
        );
        final frame = await codec.getNextFrame();
        final byteData = await frame.image.toByteData(format: ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      } catch (e) {
        //print(s);
        debugPrint('Error loading image from network: $e');
        return null;
      }
    } catch (e) {
      debugPrint('Error loading image from network: $e');
      return null;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationError = null; // Clear any previous location error
      });
      await _moveToCurrentLocation();
      await _fetchNearbyFoodTrucks();
    } catch (e) {
      // Don't prevent map from showing, just log the error and use default location
      setState(() {
        _locationError = 'Using default location: ${e.toString()}';
      });
      debugPrint('Location error: $e');
      // Still fetch food trucks for the default location
      await _fetchNearbyFoodTrucks();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
    }
  }

  Future<void> _fetchNearbyFoodTrucks() async {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(_debounceDuration, () async {
      try {
        final center = _lastCameraPosition?.target ?? _currentPosition;
        final response = await AppApi.foodTruckApi.nearBy(
          latitude: center.latitude,
          longitude: center.longitude,
          categoryIds: _selectedCategories,
          subCategoryIds: _selectedSubCategories,
          types: _selectedTypes,
        );

        _updateMarkers(response);
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint('Error fetching nearby trucks: $e');
      }
    });
  }

  void _updateMarkers(List<dynamic> foodTrucks) {
    setState(() {
      _markers.clear();
      _allFoodTrucks = foodTrucks.cast<FoodTruck>(); // Store food trucks for search
      _markers.addAll(
        foodTrucks.asMap().entries.map((entry) {
          final FoodTruck truck = entry.value;
          final position = LatLng(truck.latitude, truck.longitude);
          // Find custom icon for the truck type
          BitmapDescriptor? icon;
          for (var marker in _customMarkers) {
            if (marker['id'] as int == truck.type) {
              icon = marker['icon'];
              break;
            }
          }
          return Marker(
            markerId: MarkerId('truck_${truck.id}'),
            position: position,
            icon: icon ?? BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                InkWell(onTap: () => context.push('/view_activity/${truck.id}'), child: PopupWindow(foodTruck: truck)),
                LatLng(truck.latitude, truck.longitude),
              );
            },
          );
        }).toSet(),
      );
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // precise if allowed
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_mapControllerCompleter.isCompleted) return;
    _mapControllerCompleter.complete(controller);
    _mapController = controller;
    _mapController?.setMapStyle(_getMapStyle());
    _customInfoWindowController.googleMapController = controller;
  }

  String _getMapStyle() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? _darkMapStyle : _lightMapStyle;
  }

  Future<void> _updateMapStyle() async {
    if (_mapController != null) {
      await _mapController!.setMapStyle(_getMapStyle());
    }
  }

  void _onCameraMove(CameraPosition position) async {
    _lastCameraPosition = position;
    _customInfoWindowController.onCameraMove!();
    await _fetchNearbyFoodTrucks();
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<void> _fetchCategories() async {
    try {
      final result = await AppApi.categoryApi.list(take: 100);
      setState(() => _allCategories = result);
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> _fetchSubCategories() async {
    try {
      final result = await AppApi.subCategoryApi.list(
        take: 100,
        filter: {
          'whereIn': jsonEncode({'column': 'category_id', 'ids': _selectedCategories}),
        },
      );
      setState(() => _allSubCategories = result);
    } catch (e) {
      debugPrint('Error loading subcategories: $e');
    }
  }

  Future<void> _handleCategoryChange(List<int> selected) async {
    setState(() => _selectedCategories = selected);
    if (selected.isNotEmpty) {
      await _fetchSubCategories();
    } else {
      setState(() {
        _selectedSubCategories = [];
        _allSubCategories = [];
      });
    }
    await _fetchNearbyFoodTrucks();
  }

  void _handleSubCategoryChange(List<int> selected) async {
    setState(() => _selectedSubCategories = selected);
    await _fetchNearbyFoodTrucks();
  }

  Future<void> _openWhatsAppSupport() async {
    try {
      // Fetch contact details from API (same as contact_us_screen)
      HttpClient httpClient = HttpClient();
      final response = await httpClient.get('${AppUrl.apiUrl}/contact-us');

      String phoneNumber = response['phone'] ?? '966500000000';

      // Remove any non-numeric characters
      phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

      // Ensure country code for Saudi Arabia
      if (!phoneNumber.startsWith('966')) {
        phoneNumber = '966$phoneNumber';
      }

      // Open WhatsApp with phone number
      final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open WhatsApp')));
        }
      }
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error opening WhatsApp')));
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
    _customInfoWindowController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Stack(
              children: [
                GoogleMap(
                  key: _mapKey,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _fetchNearbyFoodTrucks,
                  onTap: (argument) => _customInfoWindowController.hideInfoWindow!(),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                  ),
                  //dark mode
                  buildingsEnabled: true,
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: MediaQuery.of(context).size.height * 0.26,
                  width: 200,
                  offset: 40,
                ),
                // Show location error as a dismissible banner at the top if there's an error
                if (_locationError != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: AppSpacing.medium,
                    right: AppSpacing.medium,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.small),
                        decoration: BoxDecoration(
                          //  color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                          //border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_off, color: Colors.orange.shade700, size: 20),
                            const SizedBox(width: AppSpacing.small),
                            Expanded(
                              child: Text(
                                _locationError!,
                                style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _locationError = null),
                              icon: Icon(Icons.close, color: Colors.orange.shade700, size: 16),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          // Search and Profile
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: AppSpacing.medium,
              right: AppSpacing.medium,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  //  TextField with TypeAheadField
                  child: // Change the TypeAheadField to work with FoodTruck directly
                      TypeAheadField<FoodTruck>(
                    hideOnUnfocus: true,

                    builder:
                        (context, controller, focusNode) => TextField(
                          key: ValueKey(S.of(context).search),
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: S.of(context).search,
                            contentPadding: EdgeInsets.all(3),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),

                    controller: _searchController,
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) return [];
                      _allFoodTrucks = await AppApi.foodTruckApi.list(search: pattern.toLowerCase());
                      return _allFoodTrucks.where((truck) {
                        return truck.name.toLowerCase().contains(pattern.toLowerCase()) ||
                            (truck.description.toLowerCase().contains(pattern.toLowerCase()));
                      }).toList();
                    },
                    itemBuilder: (context, FoodTruck suggestion) {
                      return ListTile(
                        leading:
                            _customIcon != null
                                ? Image.asset('assets/icons/truck_ic.png', width: 30, height: 30)
                                : const Icon(Icons.fastfood),
                        title: Text(suggestion.name),
                        subtitle: Text(suggestion.isOpen ? S.of(context).openNow : S.of(context).closedNow),
                      );
                    },
                    onSelected: (FoodTruck selected) {
                      _searchController.text = selected.name;
                      final position = LatLng(selected.latitude, selected.longitude);
                      if (_mapController != null) {
                        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
                        // Find and show the marker
                        final markerId = MarkerId('truck_${selected.id}');
                        _mapController!.showMarkerInfoWindow(markerId);
                      }
                      FocusScope.of(context).unfocus();
                    },
                    debounceDuration: const Duration(milliseconds: 300),
                    loadingBuilder:
                        (context) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        ),
                    emptyBuilder: (context) => ListTile(title: Text(S.of(context).noFoodTrucksFound)),
                    errorBuilder:
                        (context, error) => ListTile(
                          title: Text('Error: Error to fetch items', style: const TextStyle(color: Colors.red)),
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),

                ProfileMenu(key: _profileKey, afterCangeLanguage: () => Navigator.of(context).pop()),
              ],
            ),
          ),
          // Categories Selector
          Positioned(
            top: MediaQuery.of(context).padding.top + 30,
            left: 0,
            right: 0,
            child: CategorySelector(
              selected: _selectedCategories,
              allCategories: _allCategories,
              onChanged: _handleCategoryChange,
            ),
          ),

          // Subcategories Selector (if categories selected)
          if (_selectedCategories.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 0,
              right: 0,
              child: SubCategorySelector(
                selected: _selectedSubCategories,
                allSubCategories: _allSubCategories,
                onChanged: _handleSubCategoryChange,
              ),
            ),
          // Floating buttons: Current Location, Map Type, Filter
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Current Location Button
                FloatingActionButton(
                  heroTag: 'location_button', // Provide unique heroTag
                  backgroundColor: context.theme.primaryColor,
                  onPressed: _getCurrentLocation,
                  mini: true,
                  child: const Icon(Icons.my_location),
                ),
                // Map Type Toggle Button
                FloatingActionButton(
                  heroTag: 'map_type_button', // Provide unique heroTag
                  backgroundColor: context.theme.primaryColor,
                  onPressed: _toggleMapType,
                  mini: true,
                  child: Icon(_currentMapType == MapType.normal ? Icons.satellite : Icons.map),
                ),
                const SizedBox(height: 8),
                // WhatsApp Support Button
                FloatingActionButton(
                  heroTag: 'whatsapp_button',
                  backgroundColor: const Color(0xFF25D366), // WhatsApp green color
                  onPressed: _openWhatsAppSupport,
                  mini: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/svgs/whatsapp-svgrepo-com.svg', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
