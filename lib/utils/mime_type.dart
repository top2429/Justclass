import 'package:flutter/material.dart';

class MimeType {
  static ViewFileType toViewFileType(String mime) {
    if (mime == 'application/pdf') return ViewFileType.PDF;
    final type = mime.split('/')[0];
    if (type == 'audio') return ViewFileType.AUDIO;
    if (type == 'image') return ViewFileType.IMAGE;
    if (type == 'video') return ViewFileType.VIDEO;
    return ViewFileType.OTHER;
  }

  static IconData toIcon(String mime) {
    IconData icon;
    switch (toViewFileType(mime)) {
      case ViewFileType.AUDIO:
        icon = Icons.library_music;
        break;
      case ViewFileType.IMAGE:
        icon = Icons.image;
        break;
      case ViewFileType.VIDEO:
        icon = Icons.video_library;
        break;
      case ViewFileType.PDF:
        icon = Icons.picture_as_pdf;
        break;
      case ViewFileType.OTHER:
        icon = Icons.insert_drive_file;
        break;
    }
    return icon;
  }
}

enum ViewFileType { AUDIO, IMAGE, VIDEO, PDF, OTHER }
