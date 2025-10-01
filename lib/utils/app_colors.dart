import 'package:flutter/material.dart';

class AppColors {
  static final Color mainColor = Color(0xff0C3A5D); // primary brand color
  static final Color secondColor = Color(0xffF8A41D); // secondary color

  static final Color subColor = Color(0xff3DAE4F);

  static final whiteColor = Colors.white;
  static final blackColor = Colors.black;

  static final errorColor = Colors.redAccent;

  static final successColor = Colors.green;

  static final textGray = Color(0xffc0c0c0);

  static final appBg = Color(0xffF8F6F2);

  static MaterialColor get mainSwatch => createMaterialColor(mainColor);

  /// Generate MaterialColor from a single color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}
