import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/note_manager.dart';
import 'package:justclass/screens/edit_note_screen.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:justclass/widgets/note_file_chip.dart';
import 'package:justclass/widgets/remove_note_alert_dialog.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final Color color;

  NoteTile({this.note, this.color});

  Future<void> removeNote(BuildContext context, String uid) async {
    try {
      final noteMgr = Provider.of<NoteManager>(context, listen: false);
      var result = await showDialog<bool>(context: context, builder: (_) => RemoveNoteAlertDialog(color));

      result ??= false;
      if (result) await noteMgr.removeNote(uid, note.noteId);
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    }
  }

  void toUpdateNoteScreen(BuildContext context) {
    final noteMgr = Provider.of<NoteManager>(context, listen: false);
    final cls = Provider.of<Class>(context, listen: false);
    final theme = Themes.classThemes[cls.theme];

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => EditNoteScreen(
              note: note,
              theme: theme,
              noteManager: noteMgr,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    const double padding = 15;

    return Container(
      margin: isPortrait
          ? const EdgeInsets.symmetric(vertical: 6, horizontal: 15)
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.7),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildNoteTopBar(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: Text(note.content),
          ),
          if (note.attachments != null) buildAttachmentList(padding),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildNoteTopBar(BuildContext context) {
    final uid = Provider.of<Auth>(context, listen: false).user.uid;
    final ownerId = Provider.of<Class>(context, listen: false).ownerUid;
    final User author = note.author;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: ListTile(
            leading: MemberAvatar(photoUrl: author.photoUrl, displayName: author.displayName, color: color),
            title: Text(
              author.displayName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              DateFormat('HH:mm  MMM d yyyy').format(DateTime.fromMillisecondsSinceEpoch(note.createdAt)),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        if (uid == author.uid || uid == ownerId)
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Material(
                color: Colors.transparent,
                child: PopupMenuButton(
                  offset: const Offset(0, 10),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  tooltip: 'Options',
                  itemBuilder: (_) => [
                    if (uid == author.uid) const PopupMenuItem(child: Text('Edit'), value: 'edit', height: 40),
                    const PopupMenuItem(child: Text('Remove'), value: 'remove', height: 40),
                  ],
                  onSelected: (val) {
                    if (val == 'edit') {
                      toUpdateNoteScreen(context);
                    }
                    if (val == 'remove') {
                      removeNote(context, uid);
                    }
                  },
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildAttachmentList(double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, top: padding),
      child: Wrap(
        runSpacing: 12,
        spacing: 10,
        children: <Widget>[
          ...note.attachments.map((a) => NoteFileChip(attachment: a, color: color)).toList(),
        ],
      ),
    );
  }

  Widget buildCommentInteraction() {
    return Container();
  }
}
