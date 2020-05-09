import 'package:flutter/material.dart';

class RefreshableErrorPrompt extends StatelessWidget {
  final String message;
  final Function onRefresh;

  RefreshableErrorPrompt({this.message, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return RefreshIndicator(
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
