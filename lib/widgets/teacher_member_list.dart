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
  Member owner;
  List<Member> collaborators;

  @override
  void initState() {
    owner = widget.teachers.removeAt(0);
    collaborators = widget.teachers;

    super.initState();
  }

  void removeCollaborators(String uid) async {
    try {
      await Provider.of<Class>(context).removeCollaborator(uid);
    } catch (error) {}
  }

  void addCollaborators() {

  }

  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(color: color, title: 'Teachers', tooltip: 'New Teacher', onPressed: addCollaborators),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          leading: CircleAvatar(
            child: Image.network(owner.photoUrl),
          ),
          title: Text(owner.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15)),
        ),
        ...collaborators.map(
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
                  if (val == 'remove') removeCollaborators(t.uid);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
