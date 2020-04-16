import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/all_themes.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllThemes.primaryColor,
      body: Center(
        child: SpinKitCubeGrid(color: Colors.white70),
      ),
    );
  }
}
