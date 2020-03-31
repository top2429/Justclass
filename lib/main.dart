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
      initialRoute: LoginScreen.screenName,
      routes: {
        LoginScreen.screenName: (context) => LoginScreen(),
      },
    );
  }
}
