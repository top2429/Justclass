import 'package:flutter/material.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/screens/auth_screen.dart';
import 'package:justclass/screens/home_screen.dart';
import 'package:justclass/screens/loading_screen.dart';
import 'package:justclass/screens/user_screen_test.dart';
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
        theme: ThemeData(
          backgroundColor: const Color(0xff0c4da2), // hoa sen logo @@
          fontFamily: "OpenSans",
        ),
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
