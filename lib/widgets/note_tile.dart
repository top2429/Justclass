import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/models/user.dart';
import 'package:justclass/utils/mime_type.dart';
import 'package:justclass/widgets/member_avatar.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final Color color;

  NoteTile({this.note, this.color});

  @override
  Widget build(BuildContext context) {
    final User author = note.author;
    const double padding = 15;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.7),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: MemberAvatar(photoUrl: author.photoUrl, displayName: author.displayName, color: color),
            title: Text(
              author.displayName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              DateFormat('MMM d').format(DateTime.fromMillisecondsSinceEpoch(note.createdAt)),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: Text(note.content),
          ),
          if (note.attachments != null) buildAttachmentList(padding),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget buildAttachmentList(double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, top: padding),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: <Widget>[
          ...note.attachments
              .map((a) => Container(
                    height: 30,
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.grey.shade400, width: 0.7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(MimeType.toIcon(a.type), color: color, size: 20),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(a.name, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget buildCommentInteraction() {
    return Container();
  }
}
