import 'package:flutter/material.dart';

class AllThemes {
  static const darkBlue = Color(0xff0c4da2); // hoa sen logo @@

  static final appTheme = ThemeData(
    backgroundColor: darkBlue,
    fontFamily: "OpenSans",
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}
