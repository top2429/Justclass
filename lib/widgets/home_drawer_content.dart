import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class HomeDrawerContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          ListTile(
            title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await Provider.of<Auth>(context, listen: false).signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(AuthScreen.routeName, (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
