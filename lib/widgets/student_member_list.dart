import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:provider/provider.dart';

class StudentMemberList extends StatefulWidget {
  final List<Member> students;

  StudentMemberList({@required this.students});

  @override
  _StudentMemberListState createState() => _StudentMemberListState();
}

class _StudentMemberListState extends State<StudentMemberList> {
  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(bgColor: color, title: 'Students', tooltip: 'New Students', onPressed: () {}),
        ...widget.students.map(
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
