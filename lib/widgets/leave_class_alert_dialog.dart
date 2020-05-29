import 'package:flutter/material.dart';

class LeaveClassAlertDialog extends StatelessWidget {
  final BuildContext context;
  final String classTitle;

  LeaveClassAlertDialog({this.context, this.classTitle});

  @override
  Widget build(BuildContext _) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        ),
        alignment: Alignment.center,
        child: const Text('ARE YOU SURE?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      content: RichText(
        text: TextSpan(
          text: 'Do you really want to leave the class ',
          style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
          children: [
            TextSpan(text: classTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '?'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          disabledTextColor: Colors.grey,
          textColor: Colors.red.shade600,
          child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        FlatButton(
          child: Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
