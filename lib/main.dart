import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/screens/splash_screen.dart';
import 'package:justclass/themes.dart';
import 'package:provider/provider.dart';

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
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
            title: 'JustClass',
            theme: Themes.forApp,
            home: _buildFirstScreen(auth),
            routes: {
              AuthScreen.routeName: (_) => AuthScreen(),
              HomeScreen.routeName: (_) => HomeScreen(),
            },
          );
        },
      ),
    );
  }

  Widget _buildFirstScreen(Auth auth) {
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
