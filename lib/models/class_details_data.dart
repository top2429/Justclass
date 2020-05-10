import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';

class ClassDetailsData {
  String title;
  String subject;
  String section;
  String room;
  String description;
  PermissionCode permissionCode;
  String classCode;
  int theme;

  ClassDetailsData({
    @required this.title,
    @required this.subject,
    @required this.section,
    @required this.room,
    @required this.description,
    @required this.permissionCode,
    @required this.theme,
    this.classCode,
  });
}
