import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';

class MemberManager extends ChangeNotifier {
  List<Member> members;

  Member owner;
  List<Member> collaborators;
  List<Member> students;

  MemberManager(this.members) {
    owner = members.firstWhere((m) => m.role == ClassRole.OWNER);
    collaborators = members.where((m) => m.role == ClassRole.COLLABORATOR).toList();
    students = members.where((m) => m.role == ClassRole.STUDENT).toList();
  }

  Future<void> removeCollaborator(String uid, String cid, String memberId) async {
    final index = collaborators.indexWhere((c) => c.uid == memberId);
    final removedMember = collaborators.removeAt(index);
    notifyListeners();
    try {
      await ApiCall.removeMember(uid, cid, memberId, isStudent: false);
      members.remove(removedMember);
    } catch (error) {
      collaborators.insert(index, removedMember);
      notifyListeners();
      throw error;
    }
  }

  Future<void> removeStudent(String uid, String cid, String memberId) async {
    final index = students.indexWhere((s) => s.uid == memberId);
    final removedMember = students.removeAt(index);
    notifyListeners();
    try {
      await ApiCall.removeMember(uid, cid, memberId);
      members.remove(removedMember);
    } catch (error) {
      students.insert(index, removedMember);
      notifyListeners();
      throw error;
    }
  }

  Future<List<Member>> fetchSuggestedCollaborators(String uid, String cid, String keyword) async {
    try {
      final collaborators =
          await ApiCall.fetchSuggestedMembers(uid, cid, ClassRole.COLLABORATOR, keyword);
      return collaborators;
    } catch (error) {
      throw error;
    }
  }

  Future<List<Member>> fetchSuggestedStudents(String uid, String cid, String keyword) async {
    try {
      final students = await ApiCall.fetchSuggestedMembers(uid, cid, ClassRole.STUDENT, keyword);
      return students;
    } catch (error) {
      throw error;
    }
  }

  Future<void> inviteCollaborators(String uid, String cid, Set<String> emails) async {
    try {
      await ApiCall.inviteMembers(uid, cid, emails, ClassRole.COLLABORATOR);
    } catch (error) {
      throw error;
    }
  }

  Future<void> inviteStudents(String uid, String cid, Set<String> emails) async {
    try {
      await ApiCall.inviteMembers(uid, cid, emails, ClassRole.STUDENT);
    } catch (error) {
      throw error;
    }
  }
}
