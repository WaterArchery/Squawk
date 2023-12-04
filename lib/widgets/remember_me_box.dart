import 'package:flutter/material.dart';
import 'package:squawk/handlers/theme_handler.dart';

class RememberMeBox extends StatefulWidget {
  RememberMeBox({super.key});
  bool isChecked = false;

  @override
  State<RememberMeBox> createState() => _RememberMeBox();
}

class _RememberMeBox extends State<RememberMeBox> {
  @override
  Widget build(BuildContext context) {
    ThemeHandler themeHandler = ThemeHandler.getInstance();
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return themeHandler.getWhite();
      }
      return themeHandler.getBlack();
    }

    return Checkbox(
      checkColor: themeHandler.getWhite(),
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.isChecked,
      onChanged: (bool? value) {
        setState(() {
          widget.isChecked = value!;
        });
      },
    );
  }
}
