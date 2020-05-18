import 'package:flutter/material.dart';
import 'package:justclass/widgets/app_icon_button.dart';

class UpdateClassInfoButton extends StatefulWidget {
  final Function updateClassDetails;

  const UpdateClassInfoButton({Key key, this.updateClassDetails}) : super(key: key);

  @override
  UpdateClassInfoButtonState createState() => UpdateClassInfoButtonState();
}

class UpdateClassInfoButtonState extends State<UpdateClassInfoButton> {
  bool _isValid = true;

  void changeState(bool val) {
    setState(() => _isValid = val);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: AppIconButton(
        icon: const Icon(Icons.save),
        onPressed: !_isValid ? null : () => widget.updateClassDetails(context),
      ),
    );
  }
}
