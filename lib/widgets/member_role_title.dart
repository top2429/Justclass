import 'package:flutter/material.dart';
import 'package:justclass/widgets/app_icon_button.dart';

class MemberRoleTitle extends StatelessWidget {
  final Color color;
  final String title;
  final String tooltip;
  final Function onPressed;

  const MemberRoleTitle({
    @required this.color,
    @required this.title,
    @required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(
                this.title,
                style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            if (onPressed != null)
              AppIconButton(
                tooltip: tooltip,
                icon: Icon(Icons.person_add, color: color),
                onPressed: this.onPressed,
              ),
          ],
        ),
      ),
    );
  }
}
