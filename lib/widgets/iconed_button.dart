import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconedButton extends StatelessWidget {
  const IconedButton(this.function, this.iconData, this.buttonText, this.width, this.height, this.color, {super.key});

  final void Function() function;
  final IconData iconData;
  final String buttonText;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (buttonText != "" && width >= 180) {
      return ElevatedButton.icon(
        onPressed: function,
        icon: Icon(iconData),
        label: Text(buttonText, style: const TextStyle(fontSize: 20),),
        style: ElevatedButton.styleFrom(fixedSize: Size(width, height), backgroundColor: color),
      );
    }
    else if (buttonText != "" && width < 180) {
      return ElevatedButton.icon(
        onPressed: function,
        icon: Icon(iconData),
        label: Text(buttonText, style: GoogleFonts.roboto(fontSize: 14),),
        style: ElevatedButton.styleFrom(fixedSize: Size(width, height), backgroundColor: color),
      );
    }
    else {
      return IconButton(
        onPressed: function,
        icon: Icon(iconData),
        color: color,
        style: IconButton.styleFrom(fixedSize: Size(width, height)),
      );
    }
  }

}