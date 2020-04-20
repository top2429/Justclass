import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              final cls = Provider.of<Class>(context, listen: false);
              cls.changeTheme();
            },
          ),
        ),
      ),
    );
  }
}
