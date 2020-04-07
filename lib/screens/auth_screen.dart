import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/widgets/email_auth_form.dart';
import 'package:justclass/widgets/test_box.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: (orientation == Orientation.portrait)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Spacer(flex: 2),
                  EmailAuthForm(),
                  Spacer(),
                  TestBox(height: 100, color: Colors.lightGreen, title: "OAuth"),
                  Spacer(),
                  TestBox(height: 50, color: Colors.lightBlue, title: "Signup"),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TestBox(height: 50, color: Colors.lightBlue, title: "Signup"),
                    EmailAuthForm(),
                    TestBox(height: 100, color: Colors.lightGreen, title: "OAuth"),
                  ],
                ),
              ),
      ),
    );
  }
}
