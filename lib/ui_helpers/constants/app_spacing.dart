import 'package:flutter/widgets.dart';

class AppSpacing {
  static const double sidebarWidth = 60;
  // Define your spacing constants here
  static const double xxs = 3.0;
  static const double xs = 5.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double extraExtraLarge = 40.0;
  static const double extraExtraExtraLarge = 48.0;
  static const double highestLarge = 65.0;

  // Define EdgeInsetsGeometry for various contexts
  static const EdgeInsetsGeometry allSmall = EdgeInsets.all(small);
  static const EdgeInsetsGeometry allMedium = EdgeInsets.all(medium);
  static const EdgeInsetsGeometry allLarge = EdgeInsets.all(large);
  static const EdgeInsetsGeometry allExtraLarge = EdgeInsets.all(extraLarge);
  static const EdgeInsetsGeometry allExtraExtraLarge = EdgeInsets.all(
    extraExtraLarge,
  );

  static const EdgeInsetsGeometry horizontalSmall = EdgeInsets.symmetric(
    horizontal: small,
  );
  static const EdgeInsetsGeometry horizontalMedium = EdgeInsets.symmetric(
    horizontal: medium,
  );
  static const EdgeInsetsGeometry horizontalLarge = EdgeInsets.symmetric(
    horizontal: large,
  );
  static const EdgeInsetsGeometry horizontalExtraLarge = EdgeInsets.symmetric(
    horizontal: extraLarge,
  );

  static const EdgeInsetsGeometry verticalSmall = EdgeInsets.symmetric(
    vertical: small,
  );
  static const EdgeInsetsGeometry verticalMedium = EdgeInsets.symmetric(
    vertical: medium,
  );
  static const EdgeInsetsGeometry verticalLarge = EdgeInsets.symmetric(
    vertical: large,
  );
  static const EdgeInsetsGeometry verticalExtraLarge = EdgeInsets.symmetric(
    vertical: extraLarge,
  );

  static const EdgeInsetsGeometry onlyLeftSmall = EdgeInsets.only(left: small);
  static const EdgeInsetsGeometry onlyRightSmall = EdgeInsets.only(
    right: small,
  );
  static const EdgeInsetsGeometry onlyTopSmall = EdgeInsets.only(top: small);
  static const EdgeInsetsGeometry onlyBottomSmall = EdgeInsets.only(
    bottom: small,
  );

  static const EdgeInsetsGeometry onlyLeftMedium = EdgeInsets.only(
    left: medium,
  );
  static const EdgeInsetsGeometry onlyRightMedium = EdgeInsets.only(
    right: medium,
  );
  static const EdgeInsetsGeometry onlyTopMedium = EdgeInsets.only(top: medium);
  static const EdgeInsetsGeometry onlyBottomMedium = EdgeInsets.only(
    bottom: medium,
  );

  static const EdgeInsetsGeometry onlyLeftLarge = EdgeInsets.only(left: large);
  static const EdgeInsetsGeometry onlyRightLarge = EdgeInsets.only(
    right: large,
  );
  static const EdgeInsetsGeometry onlyTopLarge = EdgeInsets.only(top: large);
  static const EdgeInsetsGeometry onlyBottomLarge = EdgeInsets.only(
    bottom: large,
  );

  static const EdgeInsetsGeometry onlyLeftExtraLarge = EdgeInsets.only(
    left: extraLarge,
  );
  static const EdgeInsetsGeometry onlyRightExtraLarge = EdgeInsets.only(
    right: extraLarge,
  );
  static const EdgeInsetsGeometry onlyTopExtraLarge = EdgeInsets.only(
    top: extraLarge,
  );
  static const EdgeInsetsGeometry onlyBottomExtraLarge = EdgeInsets.only(
    bottom: extraLarge,
  );

  // Define spacing for specific contexts if needed
  static const EdgeInsetsGeometry horizontalExtraExtraLarge =
      EdgeInsets.symmetric(horizontal: extraExtraLarge);
  static const EdgeInsetsGeometry verticalExtraExtraLarge =
      EdgeInsets.symmetric(vertical: extraExtraLarge);

  static const EdgeInsetsGeometry allExtraExtraExtraLarge = EdgeInsets.all(
    extraExtraExtraLarge,
  );
}
