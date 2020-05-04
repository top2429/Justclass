import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OpaqueProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black38,
      alignment: Alignment.center,
      child: const SpinKitDualRing(color: Colors.white, lineWidth: 3),
    );
  }
}
