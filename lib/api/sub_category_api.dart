import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';

class SubCategoryApi extends BaseCRUDApi<SubCategory> {
  SubCategoryApi(String apiUrl) : super('$apiUrl/sub-categories');

  @override
  SubCategory fromJson(Map<String, dynamic> json) {
    return SubCategory.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(SubCategory entity) {
    return entity.toJson();
  }
}
