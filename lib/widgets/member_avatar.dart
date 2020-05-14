import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:provider/provider.dart';

class MemberAvatar extends StatelessWidget {
  final String photoUrl;
  final String displayName;

  const MemberAvatar({this.photoUrl, this.displayName});

  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    final color = Themes.forClass(cls.theme).primaryColor;
    return photoUrl == null
        ? SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: color,
              child: Text(displayName[0], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        : ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.network(photoUrl, fit: BoxFit.cover),
            ),
          );
  }
}
