// Extension to easily calculate proportional size
import 'package:flutter/material.dart';

extension ResponsiveSize on BuildContext {
  // Define a standard screen width for your calculations (e.g., 360dp/ 375dp)
  static const double standardScreenWidth = 360.0;

  double scaleFactor() {
    return MediaQuery.of(this).size.width / standardScreenWidth;
  }
}
