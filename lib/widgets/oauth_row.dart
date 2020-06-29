import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class OAuthRow extends StatelessWidget {
  final Function _setLoadingStatus;

  OAuthRow(this._setLoadingStatus);

  void _toHomeScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  void _signInFacebook(Auth auth, BuildContext context) async {
    _setLoadingStatus(true);
    try {
      // TODO: sign in with FB account
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    } finally {
      _setLoadingStatus(false);
    }
  }

  void _signInGoogle(Auth auth, BuildContext context) async {
    _setLoadingStatus(true);
    try {
      await auth.signInGoogle();
      if (auth.user != null) _toHomeScreen(context);
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    } finally {
      _setLoadingStatus(false);
    }
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
