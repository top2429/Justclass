import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/all_themes.dart';

class FetchProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDualRing(color: AllThemes.primaryColor, lineWidth: 2.5, size: 40),
    );
  }
}
