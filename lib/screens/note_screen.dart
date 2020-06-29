import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/note_manager.dart';
import 'package:justclass/screens/new_note_screen.dart';
import 'package:justclass/utils/constants.dart';
import 'package:justclass/widgets/note_screen_list.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class NoteScreen extends StatefulWidget {
  static const screenName = 'note-screen';

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    final theme = Themes.forClass(cls.theme);

    return ChangeNotifierProvider.value(
      value: NoteManager(cid: cls.cid, notes: cls.notes),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          resizeToAvoidBottomInset: false,
          body: NoteScreenList(),
          floatingActionButton: _buildAddNoteBtn(context, theme),
        );
      }),
    );
  }

  Widget _buildAddNoteBtn(BuildContext context, ClassTheme theme) {
    final auth = Provider.of<Auth>(context);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double distance = isPortrait ? portraitBottomDistance : landscapeBottomDistance;

    return SizedBox(
      width: btnHeight,
      height: distance + btnHeight,
      child: Tooltip(
        message: 'New Note',
        verticalOffset: -70,
        child: FloatingActionButton(
          elevation: 2,
          backgroundColor: theme.primaryColor,
          heroTag: 'new content',
          child: const Icon(Icons.add_comment, color: Colors.white, size: 23),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NewNoteScreen(
                  theme: theme,
                  uid: auth.user.uid,
                  noteMgr: Provider.of<NoteManager>(context),
                  cid: Provider.of<Class>(context, listen: false).cid,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
