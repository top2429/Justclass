import 'dart:math';

import 'package:flutter/material.dart';

class Themes {
  static const primaryColor = Color(0xff0c4da2); // hoa sen logo @@
  static const List<ClassTheme> _classThemes = [
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-00.jpg',
      primaryColor:  Color(0xff02579a),
      secondaryColor: Color(0xff007dde),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-01.jpg',
      primaryColor: Color(0xff2e7d32), // 800 material color
      secondaryColor: Color(0xff43a047), // 500
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-02.jpg',
      primaryColor: Color(0xff4527a0),
      secondaryColor: Color(0xff673ab7),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-03.jpg',
      primaryColor: Color(0xffad1457),
      secondaryColor: Color(0xffe91e63),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-04.jpg',
      primaryColor: Color(0xff37474f),
      secondaryColor: Color(0xff607d8b),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-05.jpg',
      primaryColor: Color(0xffef6c00),
      secondaryColor: Color(0xffff9800),
    ),
  ];

  static ClassTheme forClass(int theme) => _classThemes[theme];

  static int getRandomTheme() {
    return Random().nextInt(_classThemes.length);
  }

  static final forApp = ThemeData(
    backgroundColor: primaryColor,
    fontFamily: "OpenSans",
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}

class ClassTheme {
  final String imageUrl;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const ClassTheme({
    this.imageUrl,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
  });
}
