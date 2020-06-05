import 'package:flutter/material.dart';

enum ViewFileType { AUDIO, IMAGE, VIDEO, PDF, OTHER }

class MimeType {
  static ViewFileType toViewFileType(String mime) {
    // TODO: http.MultipartFile.fromPath automatically adds a slash to the mime type
    if (mime == 'application/pdf' || mime == 'application/pdf/') return ViewFileType.PDF;
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
