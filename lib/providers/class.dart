import 'package:flutter/foundation.dart';

enum ClassRole { OWNER, TEACHER, STUDENT, NOBODY }

extension ClassRoles on ClassRole {
  static ClassRole getType(String role) {
    if (role == 'OWNER')
      return ClassRole.OWNER;
    else if (role == 'TEACHER')
      return ClassRole.TEACHER;
    else if (role == 'STUDENT')
      return ClassRole.STUDENT;
    else
      return ClassRole.NOBODY;
  }
}

class Class with ChangeNotifier {
  final String cid;
  String title;
  String subject;
  String section;
  String description;
  String room;
  ClassRole role;
  String publicCode;
  String permissionCode;
  int theme;

  Class({
    @required this.cid,
    @required this.title,
    @required this.publicCode,
    @required this.role,
    @required this.theme,
    this.permissionCode,
    this.subject,
    this.section,
    this.description,
    this.room,
  });
}
