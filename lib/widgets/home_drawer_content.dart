import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class HomeDrawerContent extends StatelessWidget {
  Future<void> signOut(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(AuthScreen.routeName, (_) => false);
  }

  void toNotificationScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NotificationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          ListTile(
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            onTap: () => toNotificationScreen(context),
          ),
          ListTile(
            title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
