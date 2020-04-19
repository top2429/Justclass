import 'package:flutter/material.dart';

class JoinClassForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
