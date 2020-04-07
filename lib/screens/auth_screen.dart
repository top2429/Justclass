import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/widgets/email_auth_form.dart';
import 'package:justclass/widgets/oauth_row.dart';
import 'package:justclass/widgets/sign_button.dart';

class AuthScreen extends StatelessWidget {
  static final routeName = "/auth";
  final formKey = GlobalKey<EmailAuthFormState>();
  final signKey = GlobalKey();

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
                  EmailAuthForm(key: formKey),
                  Spacer(),
                  OAuthRow(),
                  Spacer(),
                  SignButton(formKey, key: signKey),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SignButton(formKey, key: signKey),
                    EmailAuthForm(key: formKey),
                    const SizedBox(height: 20),
                    OAuthRow(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
