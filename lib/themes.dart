import 'dart:math';

import 'package:flutter/material.dart';

class Themes {
  static const primaryColor = Color(0xff0c4da2); // hoa sen logo :)
  static const List<ClassTheme> _classThemes = [
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-00.jpg',
      primaryColor: Color(0xff02579a),
      secondaryColor: Color(0xff007dde),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-01.jpg',
      primaryColor: Color(0xff0b7a69),
      secondaryColor: Color(0xff0da68e),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-02.jpg',
      primaryColor: Color(0xff663bb7),
      secondaryColor: Color(0xff8255d9),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-03.jpg',
      primaryColor: Color(0xffd91a60),
      secondaryColor: Color(0xffe84a84),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-04.jpg',
      primaryColor: Color(0xff36474f),
      secondaryColor: Color(0xff647882),
    ),
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-05.jpg',
      primaryColor: Color(0xfffaa723),
      secondaryColor: Color(0xffffb745),
    ),
  ];

  static List<ClassTheme> get classThemes => [..._classThemes];

  static ClassTheme forClass(int theme) => _classThemes[theme];

  static int getRandomTheme() {
    return Random().nextInt(_classThemes.length);
  }

  static final forApp = ThemeData(
    backgroundColor: primaryColor,
    fontFamily: "OpenSans",
    accentColor: primaryColor,
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
