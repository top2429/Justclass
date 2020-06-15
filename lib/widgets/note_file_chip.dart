import 'package:dio/dio.dart';
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
  bool downloading = false;
  double percent = 0.0;
  CancelToken dioToken = CancelToken();

  @override
  void dispose() {
    dioToken.cancel();
    super.dispose();
  }

  Future<void> openFile() async {
    try {
      setState(() => downloading = true);
      await FileHandler.openFileURL(widget.attachment.fileId, widget.attachment.name, onReceiveFile, dioToken);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    } finally {
      if (this.mounted) setState(() => downloading = false);
    }
  }

  onReceiveFile(int current, int total) {
    if (!this.mounted) return;
    double result = (current / total * 100).roundToDouble() / 100;
    if (percent != result) setState(() => percent = result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: downloading ? null : openFile,
      child: Container(
        height: 30,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: widget.color.withOpacity(0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!downloading)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.centerRight,
                child: Icon(MimeType.toIcon(widget.attachment.type), color: widget.color, size: 20),
              ),
            if (downloading)
              Container(
                height: 26,
                width: 26,
                margin: const EdgeInsets.only(right: 2, left: 2),
                alignment: Alignment.centerRight,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(widget.color),
                  backgroundColor: widget.color.withOpacity(0.3),
                ),
              ),
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
