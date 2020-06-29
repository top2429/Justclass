import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/screens/invite_student_screen.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:justclass/widgets/remove_member_dialog.dart';
import 'package:provider/provider.dart';

import 'member_avatar.dart';

class StudentMemberList extends StatefulWidget {
  @override
  _StudentMemberListState createState() => _StudentMemberListState();
}

class _StudentMemberListState extends State<StudentMemberList> {
  void removeStudent(
    Member member,
    Color color,
    MemberManager memberMgr,
    String cid,
  ) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) => RemoveMemberDialog(
          title: 'STUDENT REMOVAL',
          member: member,
          color: color,
        ),
      );
      result ??= false;

      if (result) {
        final uid = Provider.of<Auth>(context, listen: false).user.uid;
        await memberMgr.removeStudent(uid, cid, member.uid);
      }
    } catch (error) {
      if (this.mounted) AppSnackBar.showContextError(context, message: error.toString());
    }
  }

  void addStudent(Color color, MemberManager memberMgr, String cid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InviteStudentScreen(
          memberMgr: memberMgr,
          color: color,
          cid: cid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    final color = Themes.forClass(cls.theme).primaryColor;
    final memberMgr = Provider.of<MemberManager>(context);

    return Column(
      children: <Widget>[
        MemberRoleTitle(
          color: color,
          title: 'Students',
          tooltip: 'Invite Students',
          onPressed: (cls.role == ClassRole.STUDENT) ? null : () => addStudent(color, memberMgr, cls.cid),
        ),
        ...memberMgr.students.map(
          (t) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            leading: MemberAvatar(photoUrl: t.photoUrl, displayName: t.displayName, color: color),
            title: Text(t.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15)),
            trailing: (cls.role != ClassRole.OWNER)
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: PopupMenuButton(
                      elevation: 5,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      itemBuilder: (_) => [const PopupMenuItem(child: Text('Remove'), value: 'remove', height: 40)],
                      onSelected: (val) {
                        if (val == 'remove') removeStudent(t, color, memberMgr, cls.cid);
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
