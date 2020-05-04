import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/widgets/email_auth_form.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';
import 'package:justclass/widgets/oauth_row.dart';
import 'package:justclass/widgets/auth_mode_changing_button.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<EmailAuthFormState>();
  final _signBtnKey = GlobalKey();
  bool _isLoading = false;

  void _changeLoadingStatus(bool status) {
    setState(() => _isLoading = status);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: orientation == Orientation.landscape,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: (orientation == Orientation.portrait)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Spacer(flex: 2),
                      EmailAuthForm(key: _formKey, changeLoadingStatus: _changeLoadingStatus),
                      Spacer(),
                      OAuthRow(_changeLoadingStatus),
                      Spacer(),
                      AuthModeChangingButton(_formKey, key: _signBtnKey),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AuthModeChangingButton(_formKey, key: _signBtnKey),
                        EmailAuthForm(key: _formKey, changeLoadingStatus: _changeLoadingStatus),
                        const SizedBox(height: 20),
                        OAuthRow(_changeLoadingStatus),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
          Visibility(
            visible: _isLoading,
            child: OpaqueProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
