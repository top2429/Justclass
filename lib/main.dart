import 'package:flutter/material.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/screens/loading_screen.dart';
import 'package:justclass/screens/user_screen_test.dart';
import 'package:justclass/all_themes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: MaterialApp(
        title: "Justclass",
        debugShowCheckedModeBanner: false,
        theme: AllThemes.appTheme,
        initialRoute: HomeScreen.routeName,
        routes: {
          LoadingScreen.routeName: (_) => LoadingScreen(),
          AuthScreen.routeName: (_) => AuthScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          UserScreen.routeName: (_) => UserScreen(),
        },
      ),
    );
  }
}
