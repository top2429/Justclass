import 'package:flutter/material.dart';

class TestBox extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String title;

  TestBox({
    this.color = Colors.white70,
    this.width = double.infinity,
    this.height = double.infinity,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: Center(
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
