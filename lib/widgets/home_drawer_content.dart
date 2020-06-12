import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/notification_screen.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

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
    final user = Provider.of<Auth>(context).user;

    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              ),
              child: ListTile(
                leading: MemberAvatar(color: Colors.red, displayName: user.displayName, photoUrl: user.photoUrl),
                title: Text(user.displayName,
                    style: const TextStyle(color: Themes.primaryColor, fontWeight: FontWeight.bold)),
                subtitle: (user.email != user.displayName)
                    ? Text(user.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              dense: true,
              leading: const Icon(Icons.notifications_none, color: Colors.white),
              title: const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () => toNotificationScreen(context),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.launch, color: Colors.white),
              title: const Text('Sign Out', style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
