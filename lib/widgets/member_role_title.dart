import 'package:flutter/material.dart';
import 'package:justclass/widgets/app_icon_button.dart';

class MemberRoleTitle extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String tooltip;
  final Function onPressed;

  const MemberRoleTitle({
    @required this.bgColor,
    @required this.title,
    @required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(this.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            AppIconButton(
              tooltip: tooltip,
              icon: const Icon(Icons.add),
              onPressed: this.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
