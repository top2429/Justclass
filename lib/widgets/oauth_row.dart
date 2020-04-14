import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/screens/user_screen_test.dart';
import 'package:provider/provider.dart';

class OAuthRow extends StatelessWidget {
  final Function _changeLoadingStatus;

  OAuthRow(this._changeLoadingStatus);

  void _toHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  void _toUserScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(UserScreen.routeName);
  }

  void _signInFacebook(Auth auth, BuildContext context) async {
    _changeLoadingStatus(true);
    try {} catch (error) {} finally {
      _changeLoadingStatus(false);
    }
  }

  void _signInGoogle(Auth auth, BuildContext context) async {
    _changeLoadingStatus(true);
    try {
      await auth.signInGoogle();
      if (auth.currentUser != null) _toUserScreen(context);
    } catch (error) {
      _showSnackBar(context, error.toString());
    } finally {
      _changeLoadingStatus(false);
    }
  }

  void _showSnackBar(BuildContext context, String error) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      content: SizedBox(
        width: double.infinity,
        child: Text(
          error,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'fb',
            backgroundColor: Colors.white,
            onPressed: () => _signInFacebook(auth, context),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/logo-fb.png", fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 50),
          FloatingActionButton(
            heroTag: 'gg',
            backgroundColor: Colors.white,
            onPressed: () => _signInGoogle(auth, context),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/logo-gg.png", fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
