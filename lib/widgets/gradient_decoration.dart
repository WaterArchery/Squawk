import 'package:flutter/material.dart';
import 'package:squawk/handlers/theme_handler.dart';

class GradientDecoration extends BoxDecoration {
  const GradientDecoration();

  BoxDecoration getDecoration() {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    final Color blueColor = themeHandler.getBlue();
    final Color redColor = themeHandler.getRed();
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            blueColor,
            redColor,
          ],
        ));
  }
}
