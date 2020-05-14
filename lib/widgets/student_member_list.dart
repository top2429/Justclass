import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:justclass/widgets/remove_member_dialog.dart';
import 'package:provider/provider.dart';

class StudentMemberList extends StatefulWidget {
  @override
  _StudentMemberListState createState() => _StudentMemberListState();
}

class _StudentMemberListState extends State<StudentMemberList> {
  void removeStudent(Member member) async {
    final memberMgr = Provider.of<MemberManager>(context, listen: false);
    try {
      final result = await showDialog(
        context: context,
        builder: (context) => RemoveMemberDialog(title: 'Remove teacher?', member: member),
      );

      if (result) await memberMgr.removeStudent(member);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  void addStudent() {}

  @override
  Widget build(BuildContext context) {
    final memberMgr = Provider.of<MemberManager>(context);
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(color: color, title: 'Students', tooltip: 'New Student', onPressed: addStudent),
        ...memberMgr.students.map(
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
                  if (val == 'remove') removeStudent(t);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
