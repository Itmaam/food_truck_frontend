import 'package:flutter/material.dart';

class WorkingHours {
  final String day;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  bool isClosed;

  WorkingHours({required this.day, this.openingTime, this.closingTime, this.isClosed = false});

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'opening_time':
          openingTime != null
              ? '${openingTime!.hour.toString().padLeft(2, '0')}:${openingTime!.minute.toString().padLeft(2, '0')}'
              : null,
      'closing_time':
          closingTime != null
              ? '${closingTime!.hour.toString().padLeft(2, '0')}:${closingTime!.minute.toString().padLeft(2, '0')}'
              : null,
      'is_closed': isClosed,
    };
  }

  @override
  String toString() {
    return 'WorkingHours{day: $day, openingTime: $openingTime, closingTime: $closingTime, isClosed: $isClosed}';
  }

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null || timeString.isEmpty) return null;
      try {
        final parts = timeString.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
      } catch (e) {
        // Invalid time format, return null
      }
      return null;
    }

    return WorkingHours(
      day: json['day'] as String,
      openingTime: parseTime(json['opening_time'] as String?),
      closingTime: parseTime(json['closing_time'] as String?),
      isClosed: json['is_closed'] as bool? ?? false,
    );
  }
}
