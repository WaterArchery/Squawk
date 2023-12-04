import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/theme_handler.dart';
import 'package:squawk/squawk.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar(this.onOpenDrawer, this.onRefreshPressed, this.onThemeChange, {super.key, required this.preferredSize});

  final void Function() onRefreshPressed;
  final void Function() onOpenDrawer;
  final void Function() onThemeChange;

  @override
  AppBar build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return AppBar(
      shadowColor: const Color.fromARGB(0, 255, 255, 255),
      title: Text("Squawk", style: GoogleFonts.lato(fontSize: 22),),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefreshPressed,
        ),
        IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: onThemeChange,
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchPressed,
        ),
      ],
      backgroundColor: themeHandler.getRed300(),
      elevation: 50.0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        tooltip: 'Menu Icon',
        onPressed: onOpenDrawer,
      ),
    );
  }

  void onSearchPressed() {
    SquawkState state = SquawkState.getState();
    state.updatePage("search");
  }

  @override
  final Size preferredSize;
}