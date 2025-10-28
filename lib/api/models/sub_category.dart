class SubCategory {
  final int id;
  final int categoryId;

  final String name;
  final String arLang;
  final dynamic icon;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.arLang,
    required this.icon,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    categoryId: json["category_id"],
    name: json["name"],
    arLang: json["ar_lang"],
    icon: json["icon"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "name": name,
    "icon": icon,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SubCategory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SubCategory($id, $name)';
}
