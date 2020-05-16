import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/utils/api_call.dart';

class MemberManager extends ChangeNotifier {
  Member owner;
  List<Member> collaborators;
  List<Member> students;
  List<Member> members;

  MemberManager(this.members) {
    owner = members.firstWhere((m) => m.role == ClassRole.OWNER);
    collaborators = members.where((m) => m.role == ClassRole.COLLABORATOR).toList();
    students = members.where((m) => m.role == ClassRole.STUDENT).toList();
  }

  Future<void> removeCollaborator(Member member) async {
    final index = collaborators.indexOf(member);
    collaborators.remove(member);
    notifyListeners();
    try {
      await ApiCall.removeCollaborator();
      members.remove(member);
    } catch (error) {
      collaborators.insert(index, member);
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> removeStudent(Member member) async {
    final index = students.indexOf(member);
    students.remove(member);
    notifyListeners();
    try {
      await ApiCall.removeStudent();
      members.remove(member);
    } catch (error) {
      students.insert(index, member);
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<List<Member>> fetchSuggestedCollaborators(String uid, String cid, String keyword) {
    try {
      final collaborators = ApiCall.fetchSuggestedMembers(uid, cid, ClassRole.COLLABORATOR, keyword);
      return collaborators;
    } catch (error) {
      throw error;
    }
  }

  Future<List<Member>> fetchSuggestedStudents(String uid, String cid, String keyword) {
    try {
      final students = ApiCall.fetchSuggestedMembers(uid, cid, ClassRole.STUDENT, keyword);
      return students;
    } catch (error) {
      throw error;
    }
  }

  Future<void> inviteCollaborators(String uid, String cid, Set<String> emails) async {
    try {
      ApiCall.inviteMembers(uid, cid, emails, ClassRole.COLLABORATOR);
    } catch (error) {
      throw error;
    }
  }
}
