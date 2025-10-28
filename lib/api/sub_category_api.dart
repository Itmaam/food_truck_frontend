import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/category.dart';

class CategoryApi extends BaseCRUDApi<Category> {
  CategoryApi(String apiUrl) : super('$apiUrl/categories');

  @override
  Category fromJson(Map<String, dynamic> json) {
    return Category.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Category entity) {
    return entity.toJson();
  }
}
