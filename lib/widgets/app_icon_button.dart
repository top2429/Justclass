import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final Function onPressed;
  final String tooltip;

  const AppIconButton({this.icon, this.onPressed, this.tooltip = 'Show menu'});

  AppIconButton.back({this.onPressed, this.icon = const Icon(Icons.arrow_back), this.tooltip = 'Back'});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: MaterialButton(
        height: 50,
        minWidth: 50,
        textColor: Colors.white,
        shape: const CircleBorder(),
        disabledTextColor: Colors.white24,
        onPressed: onPressed,
        child: Center(child: icon),
      ),
    );
  }
}
