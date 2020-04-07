import 'package:flutter/material.dart';

class OAuthRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/logo-fb.png", fit: BoxFit.contain),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 50),
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/logo-gg.png", fit: BoxFit.contain),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
