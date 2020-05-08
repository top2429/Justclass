import 'package:flutter/material.dart';
import 'package:justclass/utils/validator.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Class Code'),
                  autofocus: true,
                  onChanged: (code) {
                    _code = code;
                    setState(() => _isValid = JoinClassValidator.validateCode(code) == null);
                  },
                ),
                _buildJoinBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: RaisedButton(
        elevation: 5,
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
