import 'package:flutter/material.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/providers/note_manager.dart';

class EditNoteScreen extends StatelessWidget {
  static const routeName = 'update-note-screen';

  final Note note;
  final NoteManager noteManager;

  EditNoteScreen({this.note, this.noteManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('update note screen'),
        ),
      ),
    );
  }
}
