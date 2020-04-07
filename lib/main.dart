import 'package:flutter/material.dart';
import 'package:justclass/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Justclass",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.blue[700],
        fontFamily: "OpenSans",
      ),
      initialRoute: AuthScreen.routeName,
      routes: {
        AuthScreen.routeName: (_) => AuthScreen(),
      },
    );
  }
}
