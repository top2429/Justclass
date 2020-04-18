import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justclass/themes.dart';

class FetchProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDualRing(color: Themes.primaryColor, lineWidth: 2.5, size: 40),
    );
  }
}
