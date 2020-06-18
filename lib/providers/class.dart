import 'package:flutter/foundation.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/models/note.dart';
import 'package:justclass/utils/api_call.dart';

enum ClassRole { OWNER, COLLABORATOR, STUDENT }

extension ClassRoles on ClassRole {
  String get name {
    switch (this) {
      case ClassRole.OWNER:
        return 'OWNER';
      case ClassRole.COLLABORATOR:
        return 'COLLABORATOR';
      case ClassRole.STUDENT:
      default:
        return 'STUDENT';
    }
  }

  static ClassRole getType(String role) {
    if (role == 'OWNER')
      return ClassRole.OWNER;
    else if (role == 'COLLABORATOR')
      return ClassRole.COLLABORATOR;
    else if (role == 'STUDENT')
      return ClassRole.STUDENT;
    else
      return null;
  }
}

enum PermissionCode { VCP, VC, V }

extension PermissionCodes on PermissionCode {
  String get name {
    switch (this) {
      case PermissionCode.VCP:
        return 'VCP';
      case PermissionCode.VC:
        return 'VC';
      case PermissionCode.V:
      default:
        return 'V';
    }
  }

  static PermissionCode getType(String code) {
    if (code == 'VCP')
      return PermissionCode.VCP;
    else if (code == 'VC')
      return PermissionCode.VC;
    else if (code == 'V')
      return PermissionCode.V;
    else
      return null;
  }
}

class Class with ChangeNotifier {
  String cid;
  String title;
  String subject;
  String section;
  String description;
  String room;
  ClassRole role;
  String publicCode;
  PermissionCode permissionCode;
  int studentCount;
  String ownerName;
  String ownerUid;
  int theme;
  int createdTimestamp;
  int lastEdit;

  List<Member> _members;

  List<Note> _notes;

  Class({
    @required this.cid,
    @required this.title,
    @required this.role,
    @required this.theme,
    @required this.permissionCode,
    this.publicCode = 'Not assigned',
    this.studentCount = 0,
    this.subject = '',
    this.section = '',
    this.description = '',
    this.room = '',
    this.ownerName = '',
    this.ownerUid = '',
    this.createdTimestamp = 0,
    this.lastEdit = 0,
  });

  Class.fromJson(dynamic json) {
    this.cid = json['classroomId'];
    this.title = json['title'];
    this.subject = json['subject'];
    this.section = json['section'];
    this.room = json['room'];
    this.description = json['description'];
    this.role = ClassRoles.getType(json['role']);
    this.theme = json['theme'];
    this.publicCode = json['publicCode'];
    this.studentCount = json['studentsCount'] ?? 0;
    this.ownerName = json['owner'] != null ? json['owner']['displayName'] : '';
    this.ownerUid = json['owner'] != null ? json['owner']['localId'] : '';
    this.permissionCode = PermissionCodes.getType(json['studentsNotePermission']);
    this.createdTimestamp = json['createdTimestamp'];
    this.lastEdit = json['lastEdit'];
  }

  List<Member> get members => _members;

  List<Note> get notes => _notes;

  Future<void> fetchDetails() async {
    try {
      final data = await ApiCall.fetchClassDetails(cid);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateDetails(String uid, ClassDetailsData data) async {
    try {
      await ApiCall.updateClassDetails(uid, cid, data);
      title = data.title;
      subject = data.subject;
      section = data.section;
      room = data.room;
      theme = data.theme;
      description = data.description;
      permissionCode = data.permissionCode;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<String> resetClassCode(String uid) async {
    try {
      final code = await ApiCall.requestNewPublicCode(uid, cid);
      publicCode = code;
      return code;
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchMemberList(String uid) async {
    try {
      _members = await ApiCall.fetchMemberList(uid, cid);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchNoteList() async {
    try {
      _notes = await ApiCall.fetchNotes(cid);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
