import 'package:flutter/material.dart';

class RemoveNoteAlertDialog extends StatelessWidget {
  final Color color;

  RemoveNoteAlertDialog(this.color);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 60,
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        ),
        alignment: Alignment.center,
        child: const Text('ARE YOU SURE?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      content: Text(
        'Do you really want to remove this note?',
        style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
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
