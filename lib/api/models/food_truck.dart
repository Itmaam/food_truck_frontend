// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/category.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck_image.dart';
import 'package:food_truck_finder_user_app/api/models/menu_item.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';
import 'package:food_truck_finder_user_app/api/models/working_hours.dart';

class FoodTruck {
  final int id;
  final int userId;
  final String name;
  final String description;
  final double? rating; // Optional field for rating
  final int type;
  final List<WorkingHours>? workingHours; // Optional field for working hours

  final String phone;
  final String? website;
  final double latitude;
  final double longitude;
  final List<FoodTruckImage>? images;
  final List<Category>? categories;
  final List<SubCategory>? sub_categories;
  final List<MenuItem>? menu_items;

  FoodTruck({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
    this.rating,

    required this.phone,
    this.website,
    this.workingHours,
    required this.latitude,
    required this.longitude,
    this.images,
    this.categories,
    this.sub_categories,
    this.menu_items,
  });
  bool get isOpen {
    if (workingHours == null || workingHours!.isEmpty) return false;
    final now = DateTime.now();
    final currentDay = now.weekday - 1; // Adjust for 0-based index
    final currentHour = now.hour;
    final currentMinute = now.minute;

    final todayHours = workingHours!.firstWhere(
      (wh) => wh.day == currentDay,
      orElse: () => WorkingHours(day: currentDay.toString(), isClosed: true),
    );

    if (todayHours.isClosed) return false;

    final openingTime = todayHours.openingTime ?? TimeOfDay(hour: 0, minute: 0);
    final closingTime = todayHours.closingTime ?? TimeOfDay(hour: 23, minute: 59);
    // Convert TimeOfDay to hours and minutes for comparison
    return (currentHour > openingTime.hour ||
            (currentHour == openingTime.hour && currentMinute >= openingTime.minute)) &&
        (currentHour < closingTime.hour || (currentHour == closingTime.hour && currentMinute < closingTime.minute));
  }

  factory FoodTruck.fromJson(Map<String, dynamic> json) {
    return FoodTruck(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      rating: double.tryParse(json['avg_rating']?.toString() ?? '0.0'), // Handle null or non-numeric values
      type: json['restaurant_type'] ?? 1, // Default to 'food_truck' if type is not provided

      workingHours:
          json['working_hours'] != null
              ? (json['working_hours'] as List).map((i) => WorkingHours.fromJson(i)).toList()
              : null,
      phone: json['phone'],
      website: json['website'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      images: json['images'] != null ? (json['images'] as List).map((i) => FoodTruckImage.fromJson(i)).toList() : null,
      categories:
          json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      sub_categories:
          json['sub_categories'] != null
              ? (json['sub_categories'] as List).map((i) => SubCategory.fromJson(i)).toList()
              : null,
      menu_items:
          json['menu_items'] != null ? (json['menu_items'] as List).map((i) => MenuItem.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'phone': phone,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'working_hours': workingHours?.map((i) => i.toJson()).toList(),
      'images': images?.map((i) => i.toJson()).toList(),
      'categories': categories?.map((i) => i.id).toList(),
      'sub_categories': sub_categories?.map((i) => i.id).toList(),
      'menu_items': menu_items?.map((i) => i.toJson()).toList(),
    };
  }
}
