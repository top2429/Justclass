import 'package:flutter/material.dart';
import 'package:justclass/widgets/email_auth_form.dart';

class SignButton extends StatefulWidget {
  final GlobalKey formKey;

  SignButton(this.formKey, {Key key}) : super(key: key);

  @override
  _SignButtonState createState() => _SignButtonState();
}

class _SignButtonState extends State<SignButton> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FlatButton(
        onPressed: () {
          final state = widget.formKey.currentState as EmailAuthFormState;
          isLogin ? state.toSignUpMode() : state.toLoginMode();
          setState(() => isLogin = !isLogin);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              isLogin ? "New here? " : "Already have an account? ",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Text(
              isLogin ? "Sign Up" : "Log In",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
