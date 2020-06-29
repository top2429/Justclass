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

  Note.fromJson(dynamic json) {
    this.noteId = json['noteId'];
    this.content = json['content'];
    this.createdAt = json['createdAt'];
    this.deletedAt = json['deletedAt'];
    this.commentCount = json['commentsCount'];
    this.author = User(
      uid: json['author']['localId'],
      email: json['author']['email'],
      photoUrl: json['author']['photoUrl'],
      displayName: json['author']['displayName'],
    );

    setAttachments(json['attachments']);
  }

  void setAttachments(List<dynamic> data) {
    if (data == null) {
      this.attachments = null;
      return;
    }

    this.attachments = data
        .map((e) => Attachment(
              fileId: e['fileId'],
              type: e['type'],
              name: e['name'],
              size: e['size'],
              createdAt: e['createdAt'],
            ))
        .toList();
  }

  void setContent(String content) {
    this.content = content;
  }
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
