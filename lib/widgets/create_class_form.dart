import 'package:flutter/material.dart';

class NewClassData {
  String subject;
  String section;
  String description;

  NewClassData({
    this.subject,
    this.section,
    this.description,
  });
}

class CreateClassForm extends StatefulWidget {
  final NewClassData data;

  CreateClassForm(this.data);

  @override
  _CreateClassFormState createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  final _subjectController = TextEditingController();

  @override
  void initState() {
    _subjectController.text = widget.data.subject;
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                  controller: _subjectController,
                  onChanged: (val) {
                    widget.data.subject = val;
                  })
            ],
          ),
        ),
      ),
    );
  }
}
