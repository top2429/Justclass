import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/widgets/email_auth_form.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
            ),
            EmailAuthForm(),
            Container(
              height: 200,
              color: Colors.red,
            ),
            Container(
              height: 100,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
