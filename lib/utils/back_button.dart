import 'package:flutter/material.dart';

Widget backButton({
  required Function onTap,
  IconData icon = Icons.keyboard_arrow_left,
  Alignment alignment = Alignment.topLeft,
  Color iconColor = Colors.white,
  double padding = 20,
}) {
  return Padding(
    padding: EdgeInsets.only(left: padding, top: padding),
    child: Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(150),
          ),
          child: Icon(
            icon,
            color: iconColor,
            // size: 34,
          ),
        ),
      ),
    ),
  );
}
