import 'package:flutter/material.dart';
import 'package:justclass/widgets/auth_mode_changing_button.dart';
import 'package:justclass/widgets/email_auth_form.dart';
import 'package:justclass/widgets/oauth_row.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<EmailAuthFormState>();
  final _signBtnKey = GlobalKey();
  bool _isLoading = false;

  void _setLoadingStatus(bool status) {
    if (this.mounted) setState(() => _isLoading = status);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: !isPortrait,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              (isPortrait)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Spacer(flex: 2),
                        EmailAuthForm(key: _formKey, setLoadingStatus: _setLoadingStatus),
                        const Spacer(),
                        OAuthRow(_setLoadingStatus),
                        const Spacer(),
                        AuthModeChangingButton(_formKey, key: _signBtnKey),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          AuthModeChangingButton(_formKey, key: _signBtnKey),
                          EmailAuthForm(key: _formKey, setLoadingStatus: _setLoadingStatus),
                          const SizedBox(height: 20),
                          OAuthRow(_setLoadingStatus),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
              Visibility(
                visible: _isLoading,
                child: OpaqueProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
