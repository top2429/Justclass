import 'package:flutter/material.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/utils/mime_type.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/utils/file_handler.dart';

class NoteFileChip extends StatefulWidget {
  final Attachment attachment;
  final Color color;

  NoteFileChip({@required this.attachment, @required this.color});

  @override
  _NoteFileChipState createState() => _NoteFileChipState();
}

class _NoteFileChipState extends State<NoteFileChip> {
  Future<void> openFile() async {
    try {
      await FileHandler.openFile(widget.attachment.fileId, widget.attachment.name, onReceiveFile);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  onReceiveFile(int current, int total) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openFile,
      child: Container(
        height: 30,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: widget.color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(MimeType.toIcon(widget.attachment.type), color: widget.color, size: 20),
            const SizedBox(width: 5),
            Flexible(
              child: Text(widget.attachment.name, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
