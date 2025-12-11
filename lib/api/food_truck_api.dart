import 'dart:convert';
import 'dart:io';

import 'package:food_truck_finder_user_app/api/auth/auth_helper.dart';
import 'package:food_truck_finder_user_app/api/auth/user_auth_manager.dart';
import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/core/exceptions/server_errors.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/api/models/menu_item.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';
import 'package:http/http.dart' as http;

import 'models/category.dart';

class FoodTruckApi extends BaseCRUDApi<FoodTruck> {
  FoodTruckApi(String apiUrl) : super('$apiUrl/food-truck');

  Future<void> uploadMenuItemImage(
    String foodTruckId,
    String menuItemId,
    File image,
  ) async {
    final uri = Uri.parse(
      '${httpClient.baseUrl}/$foodTruckId/menu-items/$menuItemId/image',
    );

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] =
        'Bearer ${UserAuthManager.getBearerToken()}';

    final file = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload menu item image');
    }
  }

  @override
  FoodTruck fromJson(Map<String, dynamic> json) {
    return FoodTruck.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(FoodTruck entity) {
    return entity.toJson();
  }

  Future<List<FoodTruck>> nearBy({
    required double latitude,
    required double longitude,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? types,
  }) async {
    // List to hold individual query parameter strings
    List<String> queryParts = [];

    // Add mandatory parameters
    queryParts.add('lat=$latitude');
    queryParts.add('lng=$longitude');

    // Conditionally add category parameter
    if (categoryIds!.isNotEmpty) {
      // Encode the list as a JSON string, then URI encode the resulting string.
      // This matches the backend expectation (e.g., category="[1]" or category="[1,2]")
      queryParts.add(
        'category=${Uri.encodeQueryComponent(jsonEncode(categoryIds))}',
      );
    }

    // Conditionally add sub_category parameter
    if (subCategoryIds!.isNotEmpty) {
      queryParts.add(
        'sub_category=${Uri.encodeQueryComponent(jsonEncode(subCategoryIds))}',
      );
    }

    // Conditionally add types parameter
    if (types!.isNotEmpty) {
      queryParts.add('types=${Uri.encodeQueryComponent(jsonEncode(types))}');
    }

    // Join all parts with '&'
    final String queryString = queryParts.join('&');

    // Construct the final path
    final String urlPath = '/nearby?$queryString';
    final response = await httpClient.get(urlPath);
    if (response != null) {
      return (response as List).map((i) => FoodTruck.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<FoodTruck>> myTrucks() async {
    final response = await httpClient.get('/my-trucks');
    if (response != null) {
      return (response as List).map((i) => FoodTruck.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Category>> getCategories(String foodTruckId) async {
    final response = await httpClient.get('/$foodTruckId/categories');
    if (response != null) {
      return (response as List).map((i) => Category.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<SubCategory>> getSubCategories(String foodTruckId) async {
    final response = await httpClient.get('/$foodTruckId/sub-categories');
    if (response != null) {
      return (response as List).map((i) => SubCategory.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  Future<List<MenuItem>> getMenuItems(String foodTruckId) async {
    final response = await httpClient.get('/$foodTruckId/menu-items');
    if (response != null) {
      return (response as List).map((i) => MenuItem.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> uploadImages(String foodTruckId, List<File> images) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${httpClient.baseUrl}/$foodTruckId/upload-images'),
      );

      // Add authorization header if needed
      final bearerToken = await AuthHelper.getBearerToken();
      if (bearerToken != null) {
        request.headers['Authorization'] = 'Bearer $bearerToken';
      }

      // Add each image file to the request
      for (final image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Use array notation if your backend expects multiple files
            image.path,
          ),
        );
      }

      // Send the request
      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['message'] ??
              'Failed to upload images: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw ServerConnectionError(message: 'Error connecting to server');
    } catch (e) {
      throw Exception('Failed to upload images');
    }
  }

  Future<void> deleteImage(String foodTruckId, String imagePath) async {
    await httpClient.delete(
      '/$foodTruckId/delete-image',
      body: {'image_path': imagePath},
      headers: {'Content-Type': 'application/json'},
    );
  }
}
