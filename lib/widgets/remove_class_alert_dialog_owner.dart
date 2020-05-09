import 'package:flutter/material.dart';

class RemoveClassAlertDialogOwner extends StatefulWidget {
  final BuildContext context;
  final String classTitle;

  const RemoveClassAlertDialogOwner({this.context, this.classTitle});

  @override
  _RemoveClassAlertDialogOwnerState createState() => _RemoveClassAlertDialogOwnerState();
}

class _RemoveClassAlertDialogOwnerState extends State<RemoveClassAlertDialogOwner> {
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text(
          'ARE YOU SURE?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('All of the members and content of this class will be gone.'),
            const SizedBox(height: 15),
            const Text('Enter your class title to proceed:'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'Class Title'),
                onChanged: (val) {
                  setState(() => _isValid = val == widget.classTitle);
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            disabledTextColor: Colors.grey,
            textColor: Colors.red.shade600,
            child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: !_isValid ? null : () => Navigator.of(widget.context).pop(true),
          ),
          FlatButton(
            child: Text(
              'No',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(widget.context).pop(false),
          ),
        ],
      ),
    );
  }
}
