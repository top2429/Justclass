import 'package:flutter/material.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/refreshable_error_prompt.dart';
import 'package:justclass/widgets/student_member_list.dart';
import 'package:justclass/widgets/teacher_member_list.dart';
import 'package:provider/provider.dart';

import 'fetch_progress_indicator.dart';

class MemberList extends StatefulWidget {
  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool hasError = false;
  bool didFirstLoad = false;

  Future<void> fetchMemberListFirstLoad(Class cls, String uid) async {
    try {
      await cls.fetchMemberList(uid);
      setState(() {
        didFirstLoad = true;
      });
    } catch (error) {
      if (this.mounted) {
        AppSnackBar.showError(context, message: error.toString());
        setState(() {
          didFirstLoad = true;
          hasError = true;
        });
      }
    }
  }

  Future<void> fetchMemberList(Class cls, String uid) async {
    try {
      await cls.fetchMemberList(uid);
      setState(() => hasError = false);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    final color = Themes.forClass(cls.theme).primaryColor;
    final uid = Provider.of<Auth>(context, listen: false).user.uid;

    if (!didFirstLoad && cls.members == null) {
      fetchMemberListFirstLoad(cls, uid);
      return FetchProgressIndicator(color: color);
    }
    return (hasError)
        ? RefreshableErrorPrompt(onRefresh: () => fetchMemberList(cls, uid))
        : buildMemberList(cls, uid, color);
  }

  Widget buildMemberList(Class cls, String uid, Color color) {
    return RefreshIndicator(
      color: color,
      onRefresh: () => fetchMemberList(cls, uid),
      child: ChangeNotifierProvider.value(
        value: MemberManager(cls.members),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            TeacherMemberList(),
            const SizedBox(height: 20),
            StudentMemberList(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
