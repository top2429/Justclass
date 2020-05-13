import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/widgets/refreshable_error_prompt.dart';
import 'package:justclass/widgets/student_member_list.dart';
import 'package:justclass/widgets/teacher_member_list.dart';
import 'package:provider/provider.dart';

import 'fetch_progress_indicator.dart';

class MemberList extends StatefulWidget {
  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool hasError = false;

  get color => null;

  List<Member> getTeacherList(List<Member> members) {
    List<Member> teachers = [];
    teachers.add(members.firstWhere((m) => m.role == ClassRole.OWNER));
    teachers.addAll(members.where((m) => m.role == ClassRole.COLLABORATOR));
    return teachers;
  }

  List<Member> getStudentList(List<Member> members) {
    return members.where((m) => m.role == ClassRole.STUDENT).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context, listen: false);

    if (cls.members == null) {
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      cls.fetchMemberList(uid).then((_) {
        setState(() {});
      }).catchError((_) {
        setState(() {
          hasError = true;
        });
      });
      return FetchProgressIndicator();
    }
    return (hasError)
        ? RefreshableErrorPrompt(
            onRefresh: () {
              final uid = Provider.of<Auth>(context, listen: false).user.uid;
              return cls.fetchMemberList(uid).then((_) {
                setState(() {});
              }).catchError((_) {
                setState(() {
                  hasError = true;
                });
              });
            },
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TeacherMemberList(color: color),
                StudentMemberList(color: color),
              ],
            ),
          );
  }
}
