import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:justclass/widgets/member_role_title.dart';
import 'package:justclass/widgets/remove_member_dialog.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class TeacherMemberList extends StatefulWidget {
  @override
  _TeacherMemberListState createState() => _TeacherMemberListState();
}

class _TeacherMemberListState extends State<TeacherMemberList> {
  void removeCollaborators(Member member) async {
    final memberMgr = Provider.of<MemberManager>(context, listen: false);
    final color = Themes.forClass(Provider.of<Class>(context, listen: false).theme).primaryColor;
    try {
      final result = await showDialog(
        context: context,
        builder: (context) => RemoveMemberDialog(title: 'Remove teacher?', member: member, color: color),
      );
      if (result != null && result) await memberMgr.removeCollaborator(member);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  void addCollaborators() {}

  @override
  Widget build(BuildContext context) {
    final memberMgr = Provider.of<MemberManager>(context);
    final color = Themes.forClass(Provider.of<Class>(context).theme).primaryColor;

    return Column(
      children: <Widget>[
        MemberRoleTitle(color: color, title: 'Teachers', tooltip: 'Invite Teachers', onPressed: addCollaborators),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          leading: MemberAvatar(
            photoUrl: memberMgr.owner.photoUrl,
            displayName: memberMgr.owner.displayName,
            color: color,
          ),
          title: Text(memberMgr.owner.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15)),
        ),
        ...memberMgr.collaborators.map(
          (t) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            leading: MemberAvatar(photoUrl: t.photoUrl, displayName: t.displayName),
            title: Text(t.displayName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15)),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: PopupMenuButton(
                elevation: 5,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
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
