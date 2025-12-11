import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/favorite.dart';

class FavoriteApi extends BaseCRUDApi<Favorite> {
  FavoriteApi(String apiUrl) : super('$apiUrl/favorites');
  Future<bool> addFavorite(int foodTruckId) async {
    final response = await httpClient.post(
      '',
      body: {'food_truck_id': foodTruckId},
    );
    if (response != null) {
      return true;
    } else {
      throw Exception('Failed to add favorite');
    }
  }

  Future<bool> checkFavorite(int foodTruckId) async {
    final response = await httpClient.get('/check/$foodTruckId');

    if (response != null) {
      return response['is_favorite'] as bool;
    } else {
      return false;
      // throw Exception('Failed to check favorite status');
    }
  }

  Future<bool> removeFavorite(int foodTruckId) async {
    await httpClient.delete('/$foodTruckId');
    return true;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return Favorite.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(entity) {
    return entity.toJson();
  }
}
