import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  const AppIconButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
