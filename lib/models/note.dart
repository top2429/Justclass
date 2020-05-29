import 'package:flutter/foundation.dart';
import 'package:justclass/models/user.dart';

class Note {
  String noteId;
  String content;
  int createdAt;
  int deletedAt;
  int commentCount;
  User author;
  List<Attachment> attachments;

  Note({
    @required this.noteId,
    @required this.content,
    @required this.author,
    this.createdAt,
    this.deletedAt,
    this.commentCount,
    this.attachments,
  });
}

class Attachment {
  String fileId;
  String name;
  String type;
  int size;
  int createdAt;

  Attachment({
    @required this.fileId,
    @required this.name,
    @required this.type,
    this.size,
    this.createdAt,
  });
}
