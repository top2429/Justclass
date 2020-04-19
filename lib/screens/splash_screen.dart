import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/themes.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primaryColor,
      body: Center(
        child: Container(),
//        child: SpinKitWave(color: Colors.white70),
      ),
    );
  }
}
