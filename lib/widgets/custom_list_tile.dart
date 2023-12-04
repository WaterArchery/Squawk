import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {

  final IconData iconData;
  final String title;
  final void Function() function;

  const CustomListTile(this.iconData, this.title, this.function, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      title: Text(title),
      onTap: function,
      leading: Icon(iconData),
    );
  }
}