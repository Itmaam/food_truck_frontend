class FoodTruckImage {
  final int id;
  final String imageUrl;
  final String mainPath;

  FoodTruckImage({
    required this.id,
    required this.imageUrl,
    required this.mainPath,
  });

  factory FoodTruckImage.fromJson(Map<String, dynamic> json) {
    return FoodTruckImage(
      id: json['id'],
      imageUrl: json['image_url'],
      mainPath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image_path': imageUrl, 'main_path': mainPath};
  }
}
