import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:justclass/widgets/remove_member_dialog.dart';
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

  void removeCollaborators(Member member) async {
    final index = collaborators.indexOf(member);

    try {
      final result = await showDialog(
        context: context,
        builder: (context) => RemoveMemberDialog(title: 'Remove teacher?', member: member),
      );

      setState(() => collaborators.remove(member));
      if (result) await Provider.of<Class>(context, listen: false).removeCollaborator(member);
    } catch (error) {
      setState(() => collaborators.insert(index, member));
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  void addCollaborators() {}

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
                  if (val == 'remove') removeCollaborators(t);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
