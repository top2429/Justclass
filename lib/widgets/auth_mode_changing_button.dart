import 'package:flutter/material.dart';
import 'package:justclass/widgets/email_auth_form.dart';

class AuthModeChangingButton extends StatefulWidget {
  final GlobalKey formKey;

  AuthModeChangingButton(this.formKey, {Key key}) : super(key: key);

  @override
  _AuthModeChangingButtonState createState() => _AuthModeChangingButtonState();
}

class _AuthModeChangingButtonState extends State<AuthModeChangingButton> {
  bool isSigningIn = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          final state = widget.formKey.currentState as EmailAuthFormState;
          isSigningIn ? state.toSignUpMode() : state.toSignInMode();
          setState(() => isSigningIn = !isSigningIn);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              isSigningIn ? "New here? " : "Already have an account? ",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              isSigningIn ? "Sign Up" : "Sign In",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
