import 'package:flutter/material.dart';
import 'package:justclass/utils/validators.dart';

class CreateClassFormData {
  String title;
  String subject;
  String section;
  String description;
  String room;
  int theme;

  CreateClassFormData({
    this.title = '',
    this.subject = '',
    this.section = '',
    this.description = '',
    this.room = '',
    this.theme = 0,
  });
}

class CreateClassForm extends StatefulWidget {
  final CreateClassFormData data;
  final Function sendNewClassRequest;

  CreateClassForm(this.data, this.sendNewClassRequest);

  @override
  _CreateClassFormState createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  bool _isValid;

  @override
  void initState() {
    _isValid = CreateClassValidator.validateClassTitle(widget.data.title) == null;
    super.initState();
  }

  _sendNewClassRequest() {
    Navigator.of(context).pop();
    widget.sendNewClassRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 20, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            _buildClassNameInput(),
            const SizedBox(height: 20),
            _buildSubjectInput(),
            const SizedBox(height: 15),
            _buildSectionInput(),
            const SizedBox(height: 20),
            _buildRoomInput(),
            const SizedBox(height: 20),
            Align(alignment: Alignment.centerRight, child: _buildCreateButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return FlatButton(
      disabledColor: Colors.grey,
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: const Text(
        'Create',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: !_isValid ? null : this._sendNewClassRequest,
    );
  }

  Widget _buildClassNameInput() {
    return TextFormField(
      initialValue: widget.data.title,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: const InputDecoration(labelText: 'Class title (required)'),
      onChanged: (val) {
        widget.data.title = val;
        if (_isValid != (CreateClassValidator.validateClassTitle(val) == null)) {
          setState(() => _isValid = !_isValid);
        }
      },
    );
  }

  Widget _buildSubjectInput() {
    return TextFormField(
      initialValue: widget.data.subject,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: const InputDecoration(labelText: 'Subject'),
      onChanged: (val) => widget.data.subject = val,
    );
  }

  Widget _buildSectionInput() {
    return TextFormField(
      initialValue: widget.data.section,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      decoration: const InputDecoration(labelText: 'Section'),
      onChanged: (val) => widget.data.section = val,
    );
  }

  Widget _buildRoomInput() {
    return TextFormField(
      initialValue: widget.data.room,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(labelText: 'Room'),
      onChanged: (val) => widget.data.room = val,
    );
  }
}
