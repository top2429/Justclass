import 'package:flutter/material.dart';
import 'package:justclass/widgets/app_icon_button.dart';

import '../themes.dart';

class NewNoteScreenTeacher extends StatelessWidget {
  final ClassTheme theme;
  final String uid;
  final String cid;

  const NewNoteScreenTeacher({this.theme, this.cid, this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: AppIconButton(
          tooltip: 'Cancel',
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          AppIconButton(
            icon: const Icon(Icons.attachment),
            tooltip: 'Attachment',
            onPressed: () {},
          ),
          AppIconButton(
            icon: const Icon(Icons.send),
            tooltip: 'Post',
            onPressed: () {},
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Container(
        child: Center(
          child: Text('New Note'),
        ),
      ),
    );
  }
}
