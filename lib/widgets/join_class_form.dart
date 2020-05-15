import 'package:flutter/material.dart';
import 'package:justclass/utils/validators.dart';

class JoinClassForm extends StatefulWidget {
  final Function onJoinClass;

  const JoinClassForm({@required this.onJoinClass});

  @override
  _JoinClassFormState createState() => _JoinClassFormState();
}

class _JoinClassFormState extends State<JoinClassForm> {
  bool _isValid = false;
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Class Code'),
                autofocus: true,
                onChanged: (code) {
                  _code = code;
                  if (_isValid != (JoinClassValidator.validateCode(code) == null)) {
                    setState(() => _isValid = !_isValid);
                  }
                },
              ),
              _buildJoinBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: FlatButton(
        disabledColor: Colors.grey,
        color: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Text(
          'Join',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: !_isValid
            ? null
            : () {
                Navigator.of(context).pop();
                widget.onJoinClass(_code);
              },
      ),
    );
  }
}
