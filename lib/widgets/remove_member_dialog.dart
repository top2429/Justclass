import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';

class RemoveMemberDialog extends StatelessWidget {
  final String title;
  final Member member;

  const RemoveMemberDialog({this.title, this.member});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20)),
      content: ListTile(
        leading: CircleAvatar(child: Image.network(member.photoUrl)),
        title: Text(member.displayName),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ))),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ))),
      ],
    );
  }
}
