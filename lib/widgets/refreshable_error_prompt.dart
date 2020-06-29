import 'package:flutter/material.dart';
import 'package:justclass/themes.dart';

class RefreshableErrorPrompt extends StatelessWidget {
  final String message;
  final Function onRefresh;
  final Color color;

  RefreshableErrorPrompt({this.message, @required this.onRefresh, this.color = Themes.primaryColor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return RefreshIndicator(
          color: color,
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              SizedBox(height: (message == null) ? constraints.maxHeight * 0.45 : constraints.maxHeight * 0.42),
              Icon(Icons.error, color: Colors.amber, size: 45),
              if (message != null) const SizedBox(height: 10),
              if (message != null) Text(message, style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }
}
