import 'package:flutter/material.dart';
import 'package:justclass/widgets/member_role_title.dart';

class TeacherMemberList extends StatefulWidget {
  final Color color;

  TeacherMemberList({@required this.color});

  @override
  _TeacherMemberListState createState() => _TeacherMemberListState();
}

class _TeacherMemberListState extends State<TeacherMemberList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MemberRoleTitle(bgColor: widget.color, title: 'Teachers', tooltip: 'New Teachers', onPressed: () {}),
      ],
    );
  }
}
