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
  void removeStudent(String uid) async {
    try {
      await Provider.of<Class>(context).removeStudent(uid);
    } catch (error) {}
  }

  void addStudent() {}

  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(color: color, title: 'Students', tooltip: 'New Student', onPressed: addStudent),
        ...widget.students.map(
          (t) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            leading: CircleAvatar(
              child: Image.network(t.photoUrl),
            ),
            title: Text(t.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15)),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: PopupMenuButton(
                elevation: 5,
                itemBuilder: (_) => [const PopupMenuItem(child: Text('Remove'), value: 'remove', height: 40)],
                onSelected: (val) {
                  if (val == 'remove') removeStudent(t.uid);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
