import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Hero(
              tag: cls.cid,
              child: Image.asset(Themes.forClass(cls.theme).imageUrl, fit: BoxFit.cover),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  cls.changeTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
