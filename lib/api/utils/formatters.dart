import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

/// Format price to display
/// 1234567 => $1,234,567, 1234 => $1,234, 123 => $123
String formatPrice(double price) {
  return NumberFormat.simpleCurrency(decimalDigits: 0).format(price);
}

String formatPercentage(double number) {
  return (number * 100).toStringAsFixed(1);
}

String formatSquareFootage(double squareFootage) {
  return NumberFormat.decimalPattern().format(squareFootage);
}

String formatDateTime(
  DateTime dateTime, {
  bool short = false,
  bool relative = false,
  bool relativeIfToday = false,
}) {
  if (relative) {
    return timeago.format(dateTime);
  }

  if (relativeIfToday && dateTime.difference(DateTime.now()).inDays == 0) {
    return timeago.format(dateTime);
  }

  if (short) {
    return DateFormat.yMd().format(dateTime);
  }

  return DateFormat.yMd().add_jm().format(dateTime);
}
