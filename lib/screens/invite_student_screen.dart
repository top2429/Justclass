import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/utils/validators.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';
import 'package:provider/provider.dart';

class InviteStudentScreen extends StatefulWidget {
  static const routeName = 'invite-student-screen';
  final MemberManager memberMgr;
  final Color color;
  final String cid;

  InviteStudentScreen({
    @required this.memberMgr,
    @required this.color,
    @required this.cid,
  });

  @override
  _InviteStudentScreenState createState() => _InviteStudentScreenState();
}

class _InviteStudentScreenState extends State<InviteStudentScreen> {
  // for notification and global snackBar
  BuildContext screenCtx;

  // a flag to stop everything from running
  bool nothingView = true;

  // a flag indicating that whether suggested members are fetching
  bool isFetching = false;

  /// Only the last request having the highest index can affect UI (index == requestCount),
  /// which helps avoid collisions on UI when lots of requests are sent too fast by the user.
  int requestCount = 0;

  // a list of suggested members fetched from api
  List<Member> members;

  // a timer used to set debounce time for the method of fetching suggested members
  Timer debounce;

  // a list of chosen emails that user wants to invite
  final emails = Set<String>();

  // a flag showing that [emails] must contain at least one email
  bool areEmailsValid = false;

  //  a flag switching between suggested member list and entered recipient
  bool suggesting = true;

  // used to set input value to empty string after user choosing an email
  final inputCtrl = TextEditingController();

  // a flag indicating if invitations are being sent or not
  bool sending = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AppContext.add(screenCtx, '${InviteStudentScreen.routeName} ${widget.cid}'));
    super.initState();
  }

  @override
  void dispose() {
    debounce?.cancel();
    inputCtrl.dispose();
    AppContext.pop();
    super.dispose();
  }

  void onInputChange(String val) {
    if (val == '')
      backToFirstMode();
    else {
      nothingView = false;
      if (InviteTeacherValidator.validateEmail(val) == null) {
        setState(() {
          suggesting = false;
          isFetching = false;
          members = null;
        });
      } else {
        debounce?.cancel();
        setState(() => suggesting = true);
        // once the user stops typing, after a period of time, send a request
        debounce = Timer(const Duration(milliseconds: 500), () => showSuggestions(val));
      }
    }
  }

  void backToFirstMode() {
    nothingView = true;
    debounce?.cancel();
    setState(() {
      isFetching = false;
      suggesting = true;
      members = null;
    });
  }

  Future<void> showSuggestions(String val) async {
    if (suggesting) setState(() => isFetching = true);
    requestCount++;
    final index = requestCount;
    try {
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      final suggestedMembers = await widget.memberMgr.fetchSuggestedStudents(uid, widget.cid, val);

      // only the result of last request is assigned
      if (index == requestCount && !nothingView && suggesting && this.mounted)
        setState(() => members = suggestedMembers);
    } catch (error) {
      if (suggesting) AppSnackBar.showError(screenCtx, message: error.toString());
    } finally {
      if (index == requestCount && this.mounted && suggesting) setState(() => isFetching = false);
    }
  }

  void onSelectEmail(String email) {
    inputCtrl.clear();
    backToFirstMode();
    emails.add(email);
    checkValidEmailList();
  }

  void removeEmail(String email) {
    emails.remove(email);
    checkValidEmailList();
  }

  void checkValidEmailList() {
    setState(() {
      areEmailsValid = emails.isNotEmpty;
    });
  }

  void sendInvitations() async {
    FocusScope.of(context).unfocus();
    setState(() => sending = true);
    try {
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      await widget.memberMgr.inviteStudents(uid, widget.cid, emails);
      if (this.mounted) Navigator.of(context).pop();
      AppSnackBar.showSuccess(
        screenCtx,
        message: emails.length > 1 ? 'Invitations were sent.' : 'An invitation was sent.',
        delay: const Duration(milliseconds: 500),
      );
    } catch (error) {
      AppSnackBar.showError(screenCtx, message: error.toString());
    } finally {
      if (this.mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: widget.color,
        resizeToAvoidBottomInset: false,
        appBar: _buildTopBar(widget.color, 'Invite students'),
        body: LayoutBuilder(builder: (context, constraints) {
          screenCtx = context;
          final bottom = MediaQuery.of(context).viewInsets.bottom;
          return SafeArea(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                color: Colors.white,
                height: constraints.maxHeight,
                alignment: Alignment.topCenter,
                child: Container(
                  height: constraints.maxHeight - bottom,
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (emails.isNotEmpty) _buildEmailList(),
                            _buildTextField(),
                            _buildLoadingIndicator(),
                            if (members != null) _buildSuggestedMemberList(),
                            if (members == null && !suggesting) _buildRecipientBtn(inputCtrl.text),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: sending,
                        child: OpaqueProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecipientBtn(String email) {
    return ListTile(
      trailing: MemberAvatar(color: widget.color, displayName: email),
      title: Text('Add recipient'),
      subtitle: Text(email, overflow: TextOverflow.ellipsis),
      onTap: () => onSelectEmail(email),
    );
  }

  Widget _buildEmailList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          ...emails
              .map(
                (m) => Chip(
                  label: Text(m, overflow: TextOverflow.ellipsis),
                  deleteIcon: const Icon(Icons.clear, color: Colors.black45, size: 18),
                  onDeleted: () => removeEmail(m),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSuggestedMemberList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (members.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: const Text('No suggestions', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
        if (members.isNotEmpty)
          ...members
              .map((m) => ListTile(
                    trailing: MemberAvatar(color: widget.color, displayName: m.displayName, photoUrl: m.photoUrl),
                    title: Text(m.displayName, overflow: TextOverflow.ellipsis),
                    subtitle: Text(m.email, overflow: TextOverflow.ellipsis),
                    onTap: () => onSelectEmail(m.email),
                  ))
              .toList(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 4,
      child: (isFetching)
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(widget.color),
              backgroundColor: widget.color.withOpacity(0.5),
            )
          : Divider(color: widget.color, height: 0.5),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: inputCtrl,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        labelText: 'Name or email address',
        hasFloatingPlaceholder: false,
      ),
      onChanged: onInputChange,
    );
  }

  Widget _buildTopBar(Color bgColor, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      leading: AppIconButton.cancel(onPressed: () => Navigator.of(context).pop()),
      title: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17)),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: AppIconButton(
            icon: const Icon(Icons.send, size: 22),
            tooltip: 'Send invitations',
            onPressed: !areEmailsValid ? null : sendInvitations,
          ),
        ),
      ],
    );
  }
}
