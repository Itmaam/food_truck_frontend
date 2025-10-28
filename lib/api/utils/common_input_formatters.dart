import 'package:flutter/services.dart';

class CommonInputFormatters {
  // integer with optional minus sign
  static TextInputFormatter integerOnly = FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*'));

  // decimal with 2 digits after comma and optional minus sign
  static TextInputFormatter decimalOnly = FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]{0,2}'));

  static TextInputFormatter latLongCoordinatesOnly = FilteringTextInputFormatter.allow(
    RegExp(r'^-?[0-9]*\.?[0-9]{0,6}'),
  );

  static TextInputFormatter limitLength(int maxLength) => LengthLimitingTextInputFormatter(maxLength);

  static String parsePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) {
      return '';
    }
    if (RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      // Format as 'XXX-XXX-XXXX'
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }
}
