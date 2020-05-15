import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/utils/validators.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class InviteCollaboratorScreen extends StatefulWidget {
  final MemberManager memberMgr;
  final Color color;
  final String cid;

  InviteCollaboratorScreen({
    @required this.memberMgr,
    @required this.color,
    @required this.cid,
  });

  @override
  _InviteCollaboratorScreenState createState() => _InviteCollaboratorScreenState();
}

class _InviteCollaboratorScreenState extends State<InviteCollaboratorScreen> {
  bool nothingView = true;
  bool isLoading = false;
  int reqCount = 0;
  List<Member> members;

  final emails = Set<String>();

  Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onInputChange(String val, BuildContext context) {
    if (val == '')
      backToFirstMode();
    else {
      nothingView = false;
      if (InviteTeacherValidator.validateEmail(val) == null)
        showAddRecipientBtn(val);
      else {
        timer?.cancel();
        timer = Timer(const Duration(seconds: 1), () => showSuggestions(val, context));
      }
    }
  }

  void backToFirstMode() {
    nothingView = true;
    timer?.cancel();
    setState(() {
      isLoading = false;
      members = null;
    });
  }

  Future<void> showSuggestions(String val, BuildContext context) async {
    setState(() => isLoading = true);
    try {
      reqCount++;
      print('invite request $reqCount');
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      final suggestedMembers = await widget.memberMgr.fetchSuggestedCollaborators(uid, widget.cid, val);
      print('invite end $reqCount');
      reqCount--;
      if (reqCount == 0 && !nothingView) setState(() => members = suggestedMembers);
    } catch (error) {
      print('invite fail $reqCount');
      reqCount--;
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    } finally {
      if (reqCount == 0) setState(() => isLoading = false);
    }
  }

  void showAddRecipientBtn(String val) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: _buildTopBar(context, widget.color, 'Invite teachers'),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
              color: Colors.white,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (emails.isNotEmpty)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[],
                      ),
                    InviteTeacherTextField(onInputChange: onInputChange),
                    SizedBox(
                      height: 4,
                      child: (isLoading)
                          ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(widget.color),
                              backgroundColor: widget.color.withOpacity(0.5),
                            )
                          : Divider(color: widget.color),
                    ),
                    if (members != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ...members
                              .map((m) => ListTile(
                                    title: Text(m.displayName),
                                  ))
                              .toList(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Color bgColor, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      leading: AppIconButton.back(onPressed: () => Navigator.of(context).pop()),
      title: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17)),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: AppIconButton(
            icon: const Icon(Icons.send, size: 22),
            tooltip: 'Send invitations',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class InviteTeacherTextField extends StatelessWidget {
  final Function onInputChange;

  const InviteTeacherTextField({this.onInputChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 20),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          labelText: 'Name or email address',
          hasFloatingPlaceholder: false,
        ),
        onChanged: (val) => onInputChange(val, context),
      ),
    );
  }
}
