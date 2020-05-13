import 'package:flutter/material.dart';
import 'package:justclass/widgets/member_role_title.dart';

class StudentMemberList extends StatefulWidget {
  final Color color;

  StudentMemberList({@required this.color});

  @override
  _StudentMemberListState createState() => _StudentMemberListState();
}

class _StudentMemberListState extends State<StudentMemberList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MemberRoleTitle(bgColor: widget.color, title: 'Students', tooltip: 'New Students', onPressed: () {}),
      ],
    );
  }
}
