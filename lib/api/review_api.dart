import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/review.dart';

class ReviewApi extends BaseCRUDApi<Review> {
  ReviewApi(String baseUrl) : super('$baseUrl/food-truck');

  Future<List<Review>> getReviews(int foodTruckId) async {
    try {
      final response = await httpClient.get('/$foodTruckId/reviews');
      return (response['data'] as List).map((i) => Review.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Review> createReview(
    int foodTruckId,
    int rating,
    String comment,
    int? reviewId,
  ) async {
    try {
      final response = await httpClient.post(
        '/$foodTruckId/reviews',
        body: {'rating': rating, 'comment': comment, 'review_id': reviewId},
      );
      return Review.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Review fromJson(Map<String, dynamic> json) {
    return Review.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Review entity) {
    return entity.toJson();
  }
}
