import 'dart:math';

import 'package:flutter/material.dart';

class Themes {
  static const primaryColor = Color(0xff0c4da2); // hoa sen logo @@
  static const List<ClassTheme> _classThemes = [
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-00.jpg',
      primaryColor: primaryColor,
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-01.jpg',
      primaryColor: Color(0xff27ae60),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-02.jpg',
      primaryColor: Color(0xfff0932b),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-03.jpg',
      primaryColor: Color(0xff8e44ad),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-04.jpg',
      primaryColor: Color(0xff8e44ad),
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

  const ClassTheme({
    this.imageUrl,
    this.primaryColor,
  });
}
