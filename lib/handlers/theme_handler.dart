import 'package:flutter/material.dart';

class ThemeHandler {

  String theme = "light";
  static ThemeHandler? _themeHandler;

  ThemeHandler() {
    _themeHandler = this;
  }

  static getInstance() {
    _themeHandler ?? ThemeHandler();
    return _themeHandler;
  }

  Color getWhite() {
    if (theme == "light") {
      return Colors.white;
    }
    else {
      return Colors.black;
    }
  }

  Color getBlue() {
    if (theme == "light") {
      return Colors.blueAccent;
    }
    else {
      return Colors.black87;
    }
  }

  Color getRed() {
    if (theme == "light") {
      return Colors.redAccent;
    }
    else {
      return Colors.black;
    }
  }

  Color getBlack() {
    if (theme == "light") {
      return Colors.black;
    }
    else {
      return Colors.white;
    }
  }

  Color getCyan() {
    if (theme == "light") {
      return Colors.cyanAccent;
    }
    else {
      return Colors.white;
    }
  }

  Color getRed300() {
    if (theme == "light") {
      return Colors.red.shade300;
    }
    else {
      return Colors.black87;
    }
  }

  Color getHomeBackground() {
    if (theme == "light") {
      return const Color.fromARGB(255, 204, 149, 137);
    }
    else {
      return Colors.black87;
    }
  }

  Color getNavbarBackground() {
    if (theme == "light") {
      return const Color.fromARGB(255, 255, 128, 128);
    }
    else {
      return Colors.black87;
    }
  }

  Color getRedOrWhite() {
    if (theme == "light") {
      return Colors.redAccent;
    }
    else {
      return Colors.white;
    }
  }


  void changeTheme() {
    if (theme == "light") {
      theme = "dark";
    }
    else {
      theme = "light";
    }
  }

}