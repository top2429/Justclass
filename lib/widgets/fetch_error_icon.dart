import 'package:flutter/material.dart';

class FetchErrorPrompt extends StatelessWidget {
  final String message;

  FetchErrorPrompt({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error, color: Colors.amber.shade700, size: 50),
          if (message != null) const SizedBox(height: 10),
          if (message != null) Text(message, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
