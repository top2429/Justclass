import 'package:flutter/material.dart';
import 'package:justclass/screens/auth_screen.dart';

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
        backgroundColor: Color(0xff0c4da2), // hoa sen logo @@
        fontFamily: "OpenSans",
      ),
      initialRoute: AuthScreen.routeName,
      routes: {
        AuthScreen.routeName: (_) => AuthScreen(),
      },
    );
  }
}
