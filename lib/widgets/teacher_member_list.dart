import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class TeacherMemberList extends StatefulWidget {
  final List<Member> teachers;

  TeacherMemberList({@required this.teachers});

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
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(bgColor: color, title: 'Teachers', tooltip: 'New Teachers', onPressed: () {}),
        ...widget.teachers.map(
          (t) => ListTile(
            leading: CircleAvatar(
              child: Image.network(t.photoUrl),
            ),
            title: Text(t.displayName),
          ),
        ),
      ],
    );
  }
}
