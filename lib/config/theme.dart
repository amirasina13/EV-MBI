import 'package:flutter/material.dart';
import 'config.dart';

// FOR CUSTOM THEME

// Ref: Font Weights: https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html
// Ref: Font Weights for TextTheme: https://api.flutter.dev/flutter/material/TextTheme-class.html
class MainTheme {
  static ThemeData of(BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      fontFamily: fontFamilyMain,

      primaryColor: mainColor,
      primaryColorLight: colorDarkGray,
      dividerColor: colorTransparent,

      colorScheme: ColorScheme.fromSeed(seedColor: mainColor),

      appBarTheme: const AppBarTheme(
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        titleTextStyle: TextStyle(
          fontFamily: fontFamilyMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorBlack,
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: colorBlack,
        ),

        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorBlack,
        ),

        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorBlack,
        ),

        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorBlack,
        ),

        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: colorBlack,
        ),

        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorBlack,
        ),
      ),

      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: colorBlueGradient,
      ),

      buttonTheme: const ButtonThemeData(minWidth: 50),
    );
  }
}
