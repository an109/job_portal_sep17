// responsive_extensions.dart
import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;
  Orientation get orientation => MediaQuery.of(this).orientation;

  // Responsive size calculator
  double rw(double percent) => screenWidth * percent / 100;
  double rh(double percent) => screenHeight * percent / 100;

  // Responsive padding
  EdgeInsets get responsivePadding => EdgeInsets.all(rw(4));

  // Responsive font size
  double responsiveFontSize({double baseSize = 16}) {
    return (baseSize * (screenWidth / 360)).clamp(baseSize * 0.8, baseSize * 1.5);
  }
}