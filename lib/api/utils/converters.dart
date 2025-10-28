import 'dart:ui';

int convertTimeStringToMinutes(String timeString) {
  List<String> timeComponents = timeString.split(':');

  int hours = int.parse(timeComponents[0]);
  int minutes = int.parse(timeComponents[1]);
  int seconds = num.parse(timeComponents[2]).toInt();

  int totalMinutes = hours * 60 + minutes + (seconds > 0 ? 1 : 0);

  return totalMinutes;
}

String convertMinutesToTimeString(int minutes) {
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;
  int seconds = 0;

  String formattedTime =
      '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  return formattedTime;
}

Color? convertHexToColor(String? color) {
  if (color == null) {
    return null;
  }

  final hexColor = color.replaceAll('#', '');

  if (hexColor.length != 6) {
    return null;
  }

  return Color(int.parse('FF$hexColor', radix: 16));
}

String convertColorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).substring(2)}'.toUpperCase();
}
