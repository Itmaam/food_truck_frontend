import 'package:food_truck_finder_user_app/api/models/food_truck.dart';

class Favorite {
  final int id;
  final int userId;
  final int foodTruckId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FoodTruck? foodTruck;

  Favorite({
    required this.id,
    required this.userId,
    required this.foodTruckId,
    required this.createdAt,
    this.updatedAt,
    this.foodTruck,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      userId: json['user_id'],
      foodTruckId: json['food_truck_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      foodTruck: json['food_truck'] != null ? FoodTruck.fromJson(json['food_truck']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'food_truck_id': foodTruckId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
