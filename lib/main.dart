import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/providers/notification_manager.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/screens/splash_screen.dart';
import 'package:justclass/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ClassManager>(
          create: (_) => ClassManager(),
          update: (_, auth, classMgr) => classMgr..uid = auth.user.uid,
        ),
        ChangeNotifierProxyProvider<Auth, NotificationManager>(
          create: (_) => NotificationManager(),
          update: (_, auth, notMgr) => notMgr..uid = auth.user.uid,
        ),
      ],
      child: MaterialApp(
        title: 'JustClass',
        theme: Themes.forApp,
        home: FirstScreen(),
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
        },
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return (auth.user == null)
        ? FutureBuilder(
            future: auth.tryAutoSignIn(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return SplashScreen();
              return AuthScreen();
            },
          )
        : HomeScreen();
  }
}
