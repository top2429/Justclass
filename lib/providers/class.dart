import 'package:flutter/foundation.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/utils/api_call.dart';

enum ClassRole { OWNER, COLLABORATOR, STUDENT, NOBODY }

extension ClassRoles on ClassRole {
  static ClassRole getType(String role) {
    if (role == 'OWNER')
      return ClassRole.OWNER;
    else if (role == 'TEACHER')
      return ClassRole.COLLABORATOR;
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
  int studentCount;
  String ownerName;
  int theme;

  Class({
    @required this.cid,
    @required this.title,
    @required this.role,
    @required this.theme,
    this.publicCode = 'Not assigned',
    this.studentCount = 0,
    this.permissionCode = '',
    this.subject = '',
    this.section = '',
    this.description = '',
    this.room = '',
    this.ownerName = '',
  });

  Future<void> fetchDetails() async {
    try {
      final data = await ApiCall.fetchClassDetails(cid);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void changeTheme() {
    theme = Themes.getRandomTheme();
    notifyListeners();
  }
}
