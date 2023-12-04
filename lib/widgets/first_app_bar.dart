import 'package:flutter/material.dart';
import 'package:squawk/handlers/theme_handler.dart';

class FirstAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FirstAppBar(this.onThemeChange, {super.key, required this.preferredSize});

  final void Function() onThemeChange;

  @override
  AppBar build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return AppBar(
      backgroundColor: themeHandler.getRed(),
      title: const Text(
        "Welcome to Squawk",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: onThemeChange,
        icon: const Icon(Icons.dark_mode),
      ),
    );
  }


  @override
  final Size preferredSize;
}