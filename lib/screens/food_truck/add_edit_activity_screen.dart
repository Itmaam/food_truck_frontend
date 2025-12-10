// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/models/category.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck_image.dart';
import 'package:food_truck_finder_user_app/api/models/menu_item.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';
import 'package:food_truck_finder_user_app/api/models/working_hours.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/location_section.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/menu_items_section.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/photos_section.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/working_hours_section.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:food_truck_finder_user_app/api/core/http_client.dart';

class AddEditActivityScreen extends StatefulWidget {
  final String? foodTruckId;

  const AddEditActivityScreen({super.key, this.foodTruckId});

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<File> _photos = [];
  List<String> _existingImageUrls = [];
  List<FoodTruckImage> _existingImage = [];

  bool _isLoading = false;
  bool _isEditing = false;
  List<MenuItem> _menuItems = [MenuItem(id: 0, foodTruckId: 0, name: '')];

  LatLng _selectedLocation = const LatLng(24.7136, 46.6753);

  List<Category> _selectedCategories = [];
  List<SubCategory> _selectedSubCategories = [];
  List<Category> _allCategories = [];
  List<SubCategory> _allSubCategories = [];
  List<dynamic> _allTypes = [];

  List<WorkingHours> _workingHours = [
    WorkingHours(day: 'Monday'),
    WorkingHours(day: 'Tuesday'),
    WorkingHours(day: 'Wednesday'),
    WorkingHours(day: 'Thursday'),
    WorkingHours(day: 'Friday'),
    WorkingHours(day: 'Saturday'),
    WorkingHours(day: 'Sunday'),
  ];

  Future<void> _loadExistingFoodTruck() async {
    try {
      setState(() => _isLoading = true);
      final foodTruck = await AppApi.foodTruckApi.getById(int.parse(widget.foodTruckId!));

      // Load all data first
      final categories = await AppApi.foodTruckApi.getCategories(widget.foodTruckId!);
      final subCategories = await AppApi.foodTruckApi.getSubCategories(widget.foodTruckId!);
      final menuItems = await AppApi.foodTruckApi.getMenuItems(widget.foodTruckId!);

      // Set initial categories and subcategories
      setState(() {
        _selectedCategories = categories;
        _selectedSubCategories = subCategories;
      });

      // Load available subcategories for these categories
      await _fetchSubCategories();

      // Now set all other state
      setState(() {
        _existingImageUrls = foodTruck.images?.map((img) => img.imageUrl).toList() ?? [];
        _existingImage = foodTruck.images ?? [];

        _selectedLocation = LatLng(foodTruck.latitude, foodTruck.longitude);

        // Initialize menu items
        if (menuItems.isNotEmpty) {
          _menuItems = menuItems;
        } else {
          _menuItems = [MenuItem(id: 0, foodTruckId: 0, name: '')];
        }

        // Initialize working hours if they exist
        if (foodTruck.workingHours != null && foodTruck.workingHours!.isNotEmpty) {
          _workingHours = foodTruck.workingHours!;
        }
      });

      // Initialize form data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': foodTruck.name,
          'description': foodTruck.description,
          'phone': foodTruck.phone,
          'website': foodTruck.website,
          'type': foodTruck.type,
        });
      });
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToLoad)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final result = await AppApi.categoryApi.list(take: 1000);
      setState(() {
        _allCategories = result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchSubCategories() async {
    try {
      final result = await AppApi.subCategoryApi.list(
        take: 1000,
        filter: {
          'whereIn': jsonEncode({'column': 'category_id', 'ids': _selectedCategories.map((item) => item.id).toList()}),
        },
      );
      setState(() {
        _allSubCategories = result;
      });
    } catch (e) {
      log('Error loading subcategories: $e');
    }
  }

  //fetch restaurant types
  Future<void> _fetchRestaurantTypes() async {
    try {
      HttpClient httpClient = HttpClient();
      final response = await httpClient.get('${AppUrl.apiUrl}/restaurant-types');
      setState(() {
        _allTypes = (response as List).map((item) => item).toList();
      });
    } catch (e) {
      debugPrint('Error loading restaurant types: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.foodTruckId != null;
    _fetchRestaurantTypes();
    _fetchCategories();
    if (_isEditing) {
      _loadExistingFoodTruck();
    } else {
      _formKey.currentState?.patchValue({'website': "https://"});
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      if (_photos.isEmpty && _existingImageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).atleastOnePhoto)));
        return;
      }

      setState(() => _isLoading = true);

      try {
        final formData = _formKey.currentState!.value;

        // Prepare menu items data without images
        final menuItems =
            _menuItems
                .where((item) => item.name.isNotEmpty)
                .map(
                  (item) => MenuItem(
                    id: item.id,
                    foodTruckId: item.foodTruckId,
                    name: item.name,
                    description: item.description,
                    imageUrl: item.imageUrl,
                  ),
                )
                .toList();

        final FoodTruck requestData = FoodTruck(
          id: _isEditing ? int.parse(widget.foodTruckId!) : 0,
          userId: 0, // Will be set by backend
          name: formData['name'],
          description: formData['description'],
          type: formData['type'],
          phone: formData['phone'],
          website: (!_isEditing ? 'https://' : '') + formData['website'],
          latitude: _selectedLocation.latitude,
          longitude: _selectedLocation.longitude,
          categories: _selectedCategories.map((c) => c).toList(),
          subCategories: _selectedSubCategories.map((sc) => sc).toList(),
          menuItems: menuItems,
          workingHours: _workingHours,
        );

        FoodTruck foodTruck;

        if (_isEditing) {
          // Update existing food truck
          foodTruck = await AppApi.foodTruckApi.update(int.parse(widget.foodTruckId!), requestData);

          // Upload main photos if any
          if (_photos.isNotEmpty) {
            await AppApi.foodTruckApi.uploadImages(widget.foodTruckId!, _photos);
          }
        } else {
          // Create new food truck
          foodTruck = await AppApi.foodTruckApi.create(requestData);

          // Upload main photos if any
          if (_photos.isNotEmpty) {
            await AppApi.foodTruckApi.uploadImages(foodTruck.id.toString(), _photos);
          }
        }

        // Handle menu item images
        await _processMenuItemImages(foodTruck);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Food truck ${_isEditing ? 'updated' : 'created'} successfully')));
          context.push('/profile');
        }
      } catch (e, s) {
        debugPrint('Error: $e');
        debugPrint('Stack trace: $s');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error ${_isEditing ? 'updating' : 'creating'} food truck'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _processMenuItemImages(FoodTruck foodTruck) async {
    for (final item in _menuItems.where((i) => i.imageFile != null || i.imageUrl != null)) {
      try {
        if (item.imageFile != null) {
          // Handle new image upload
          if (item.id == 0) {
            // Find matching created menu item
            final createdItem = foodTruck.menuItems?.firstWhere(
              (m) => m.name == item.name && m.description == item.description,
              orElse: () => MenuItem(id: 0, foodTruckId: 0, name: '', description: ''),
            );

            if (createdItem?.id != null) {
              await AppApi.foodTruckApi.uploadMenuItemImage(
                foodTruck.id.toString(),
                createdItem!.id.toString(),
                item.imageFile!,
              );
            }
          } else {
            // Update existing menu item image
            await AppApi.foodTruckApi.uploadMenuItemImage(foodTruck.id.toString(), item.id.toString(), item.imageFile!);
          }
        }
        // If imageUrl exists but no imageFile, it means we're keeping the existing image
      } catch (e) {
        debugPrint('Failed to process image for menu item ${item.name}: $e');
        // Continue with next item even if one fails
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        leading: IconButton(onPressed: () => context.push('/profile'), icon: const Icon(Icons.arrow_back)),
        title: Text(_isEditing ? S.of(context).editTruck : S.of(context).editTruck),
      ),
      body:
          _isLoading && _isEditing
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PhotosSection(
                          existingImageUrls: _existingImageUrls,
                          photos: _photos,
                          onPhotosChanged: (newPhotos) => setState(() => _photos.addAll(newPhotos)),
                          onDeleteExistingImage: (index) async {
                            try {
                              setState(() => _isLoading = true);

                              await AppApi.foodTruckApi.deleteImage(
                                widget.foodTruckId!,
                                _existingImage[index].mainPath,
                              );

                              setState(() {
                                _existingImageUrls.removeAt(index);
                                _isLoading = false;
                              });
                            } catch (e, s) {
                              log(e.toString());
                              log(s.toString());
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('Failed to delete image: ${e.toString()}')));
                            } finally {
                              if (mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                          onRemovePhoto: (index) => setState(() => _photos.removeAt(index)),
                        ),
                        const SizedBox(height: 16),

                        // Activity Details Section
                        Text(S.of(context).truckDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(labelText: S.of(context).name),
                          validator: FormBuilderValidators.required(errorText: S.of(context).nameRequiredError),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        FormBuilderTextField(
                          name: 'description',
                          decoration: InputDecoration(labelText: S.of(context).description),
                          maxLines: 3,
                          validator: FormBuilderValidators.required(errorText: S.of(context).required),
                        ),
                        const SizedBox(height: AppSpacing.medium),

                        FormBuilderDropdown(
                          name: 'type',
                          items:
                              _allTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type['id'],
                                  child: Text(
                                    Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                                        ? type['arLang'] ?? ''
                                        : type['name'],
                                  ),
                                );
                              }).toList(),
                          decoration: InputDecoration(labelText: S.of(context).restaurant_type),
                          validator: FormBuilderValidators.required(errorText: S.of(context).required),
                        ),

                        const SizedBox(height: AppSpacing.medium),

                        // Categories Section
                        Text(S.of(context).category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        FormBuilderFilterChips<Category>(
                          initialValue: _selectedCategories,
                          name: 'categories',
                          spacing: 2.0,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: S.of(context).required),
                          ]),
                          padding: EdgeInsets.all(AppSpacing.xs),
                          decoration: const InputDecoration(border: InputBorder.none),
                          options:
                              _allCategories
                                  .map(
                                    (category) => FormBuilderChipOption(
                                      value: category,
                                      child: Text(
                                        Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                                            ? category.arLang
                                            : category.name,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (List<Category>? value) async {
                            setState(() => _selectedCategories = value!);
                            await _fetchSubCategories();
                          },
                        ),
                        const SizedBox(height: AppSpacing.medium),

                        // Subcategories Section
                        if (_selectedCategories.isNotEmpty) ...[
                          Text(
                            S.of(context).subCategories,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: AppSpacing.medium),
                          FormBuilderFilterChips<SubCategory>(
                            name: 'subcategories',
                            initialValue: _selectedSubCategories,
                            decoration: const InputDecoration(border: InputBorder.none),
                            spacing: 2.0,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: S.of(context).required),
                            ]),
                            options:
                                _allSubCategories
                                    .map(
                                      (sub) => FormBuilderChipOption(
                                        value: sub,
                                        child: Text(
                                          Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                                              ? sub.arLang
                                              : sub.name,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() => _selectedSubCategories = value?.toList() ?? []);
                            },
                          ),
                          SizedBox(height: AppSpacing.medium),
                        ],

                        // Menu Items Section
                        MenuItemsSection(
                          menuItems: _menuItems,
                          onRemoveItem: (index) {
                            if (_menuItems.length > 1) {
                              setState(() => _menuItems.removeAt(index));
                            } else {
                              // Clear the fields if it's the last item
                              setState(() {
                                _menuItems[0] = MenuItem(id: 0, foodTruckId: 0, name: '');
                              });
                            }
                          },
                          onAddItem: () {
                            setState(() => _menuItems.add(MenuItem(id: null, foodTruckId: 0, name: '')));
                          },
                          onImageSelected: (index, image) {
                            setState(() {
                              _menuItems[index].imageFile = image;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Working Hours Section
                        WorkingHoursSection(
                          initialHours: _workingHours,
                          onHoursChanged: (hours) {
                            setState(() {
                              _workingHours = hours;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Location Section
                        LocationSection(
                          initialLocation: _selectedLocation,
                          onLocationChanged: (position) => setState(() => _selectedLocation = position),
                        ),
                        const SizedBox(height: 16),

                        // Contact Info Section
                        Text(S.of(context).contactInfo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'phone',
                          decoration: InputDecoration(labelText: S.of(context).phoneNumber),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        FormBuilderTextField(
                          name: 'website',
                          decoration: InputDecoration(prefix: Text('https://'), labelText: S.of(context).website),
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 16),

                        // Submit Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            icon:
                                _isLoading
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                    : const Icon(Icons.save),
                            label: Text(
                              _isLoading
                                  ? _isEditing
                                      ? '${S.of(context).update}...'
                                      : '${S.of(context).create}...'
                                  : _isEditing
                                  ? S.of(context).update
                                  : S.of(context).create,
                            ),
                            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.large),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
