import 'package:food_truck_finder_user_app/api/core/base_crud_api.dart';
import 'package:food_truck_finder_user_app/api/models/notification.dart';

class NotificationApi extends BaseCRUDApi {
  NotificationApi(String baseUrl) : super('$baseUrl/notifications');

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await httpClient.get('/');

    if (response != null) {
      final data = response;

      return {
        'notifications':
            (data['notifications']['data'] as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList(),
        'unread_count': data['unread_count'],
      };
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markAsRead(String id) async {
    final response = await httpClient.post('/$id/mark-read');

    if (response != null) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead() async {
    final response = await httpClient.post('/mark-all-read');

    if (response != null) {
      throw Exception('Failed to mark all notifications as read');
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(entity) {
    return entity.toJson();
  }
}
