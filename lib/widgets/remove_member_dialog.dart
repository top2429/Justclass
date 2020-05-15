import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/widgets/member_avatar.dart';

class RemoveMemberDialog extends StatelessWidget {
  final String title;
  final Member member;
  final Color color;

  RemoveMemberDialog({this.title, this.member, this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      content: ListTile(
        leading: MemberAvatar(photoUrl: member.photoUrl, displayName: member.displayName, color: color),
        title: Text(member.displayName),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red))),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ],
    );
  }
}
