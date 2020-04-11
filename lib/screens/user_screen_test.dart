import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    final userMgr = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(userMgr.currentUser.email),
            Image.network(userMgr.currentUser.photoUrl),
            RaisedButton(
              child: const Text('Sign out'),
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false).signOut();
                Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
