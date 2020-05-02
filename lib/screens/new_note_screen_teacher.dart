import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:justclass/utils/validator.dart';
import 'package:justclass/widgets/app_icon_button.dart';

import '../themes.dart';

class NewNoteScreenTeacher extends StatefulWidget {
  final ClassTheme theme;
  final String uid;
  final String cid;

  const NewNoteScreenTeacher({this.theme, this.cid, this.uid});

  @override
  _NewNoteScreenTeacherState createState() => _NewNoteScreenTeacherState();
}

class _NewNoteScreenTeacherState extends State<NewNoteScreenTeacher> {
  bool valid = false;
  Map<String, String> files;

  void _pickFiles() async {
    FilePicker.clearTemporaryFiles();
    files = await FilePicker.getMultiFilePath(type: FileType.any);
  }

  void _sendNote() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            _buildNoteInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: widget.theme.primaryColor,
      leading: AppIconButton(
        tooltip: 'Cancel',
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        AppIconButton(
          icon: const Icon(Icons.attachment),
          tooltip: 'Attachment',
          onPressed: _pickFiles,
        ),
        AppIconButton(
          icon: const Icon(Icons.send),
          tooltip: 'Post',
          onPressed: !valid ? null : _sendNote,
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(labelText: 'Share with your class'),
        onChanged: (val) {
          setState(() {
            valid = NewNoteValidator.validateNote(val) == null;
          });
        },
      ),
    );
  }
}
