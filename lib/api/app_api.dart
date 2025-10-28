import 'package:food_truck_finder_user_app/api/category_api.dart';
import 'package:food_truck_finder_user_app/api/favorite_api.dart';
import 'package:food_truck_finder_user_app/api/food_truck_api.dart';
import 'package:food_truck_finder_user_app/api/notification_api.dart';
import 'package:food_truck_finder_user_app/api/password_reset_api.dart';
import 'package:food_truck_finder_user_app/api/sub_category_api.dart';
import 'package:food_truck_finder_user_app/api/user_api.dart';
import 'package:food_truck_finder_user_app/api/review_api.dart';

class AppApi {
  static late final CategoryApi categoryApi;
  static late final SubCategoryApi subCategoryApi;
  static late final UserApi user;
  static late final FoodTruckApi foodTruckApi;
  static late final FavoriteApi favoriteApi;
  static late final ReviewApi reviewApi;
  static late final NotificationApi notificationApi;
  static late final PasswordResetApi passwordResetApi;

  static void init(String apiUrl) {
    user = UserApi(apiUrl);
    categoryApi = CategoryApi(apiUrl);
    subCategoryApi = SubCategoryApi(apiUrl);
    foodTruckApi = FoodTruckApi(apiUrl);
    favoriteApi = FavoriteApi(apiUrl);
    reviewApi = ReviewApi(apiUrl);
    notificationApi = NotificationApi(apiUrl);
    passwordResetApi = PasswordResetApi(apiUrl);
  }
}
