import 'package:flutter/material.dart';

class AllThemes {
  static const primaryColor = Color(0xff0c4da2); // hoa sen logo @@
  static const List<ClassTheme> _classThemes = [
    ClassTheme(
      imageUrl: 'assets/images/themes/theme-00.jpg',
      primaryColor: primaryColor,
    ),
  ];

  static ClassTheme classTheme(int theme) => _classThemes[theme];

  static final appTheme = ThemeData(
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
