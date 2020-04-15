import 'package:flutter/material.dart';

class AllThemes {
  static const primaryColor = Color(0xff0c4da2); // hoa sen logo @@

  static final appTheme = ThemeData(
    backgroundColor: primaryColor,
    fontFamily: "OpenSans",
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}
