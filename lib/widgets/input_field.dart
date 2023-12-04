import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squawk/handlers/theme_handler.dart';

class InputField extends StatelessWidget {
  const InputField(this.text, this.controller, this.hide, this.width, this.height, {super.key});

  final String text;
  final TextEditingController controller;
  final bool hide;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: hide,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: themeHandler.getBlack(),
            ),
          ),
          labelText: text,
          labelStyle: GoogleFonts.lato(color: Colors.white),
        ),
      ),
    );
  }
}