import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/notification_screen.dart';
import 'package:justclass/widgets/member_avatar.dart';
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
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 45),
            buildUserInfoBar(context),
            const SizedBox(height: 20),
            buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfoBar(BuildContext context) {
    final user = Provider.of<Auth>(context).user;

//    Color color;
//    try {
//      final theme = Provider.of<Class>(context).theme;
//      color = Themes.classThemes[theme].primaryColor;
//    } catch (error) {
//      color = Themes.primaryColor;
//    }

    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
//        border: const Border(right: BorderSide(color: Colors.white54, width: 3)),
//        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 0))],
        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(1.6),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: const BorderRadius.all(Radius.circular(21.6)),
          ),
          child: MemberAvatar(color: Colors.red, displayName: user.displayName, photoUrl: user.photoUrl),
        ),
        title: Text(
          user.displayName,
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        subtitle: (user.email != user.displayName)
            ? Text(user.email,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ))
            : null,
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: const Icon(Icons.notifications_none, color: Colors.white),
            title: const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 15)),
            onTap: () => toNotificationScreen(context),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.launch, color: Colors.white),
            title: const Text('Sign Out', style: TextStyle(color: Colors.white, fontSize: 15)),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
