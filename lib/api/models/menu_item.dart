import 'dart:io';

class MenuItem {
  final int? id;
  final int foodTruckId;
  String name;
  String? description;
  final String? imageUrl;
  File? imageFile;

  MenuItem({
    required this.id,
    required this.foodTruckId,
    required this.name,
    this.description,
    this.imageUrl,
    this.imageFile,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      foodTruckId: json['food_truck_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'food_truck_id': foodTruckId, 'name': name, 'description': description};
  }
}
