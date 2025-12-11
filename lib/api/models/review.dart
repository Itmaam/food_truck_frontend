import 'package:intl/intl.dart';
import 'package:food_truck_finder_user_app/api/models/user.dart';

class Review {
  final int id;
  final int userId;
  final dynamic foodTruckId;
  final int rating;
  final String comment;
  User? user;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.foodTruckId,
    required this.rating,
    required this.comment,
    this.user,
    required this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      foodTruckId: json['food_truck_id'],
      rating: json['rating'],
      comment: json['comment'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy hh:mm a').format(createdAt);
  }

  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'food_truck_id': foodTruckId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
