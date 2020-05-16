import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justclass/models/member.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/utils/validators.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
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
  // a flag to stop everything from running
  bool nothingView = true;

  // a flag indicating that whether suggested members is fetching
  bool isLoading = false;

  //only the last request having the highest index can execute (index == requestCount)
  int requestCount = 0;

  // a list of suggested members fetched from api
  List<Member> members;

  // a timer used to set timeout for the method of fetching suggested members
  Timer timer;

  // a list of chosen emails that user wants to invite
  final emails = Set<String>();
  bool areEmailsValid = false;

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
        timer = Timer(const Duration(milliseconds: 700), () => showSuggestions(val, context));
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
    requestCount++;
    final index = requestCount;
    try {
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      final suggestedMembers = await widget.memberMgr.fetchSuggestedCollaborators(uid, widget.cid, val);

      // only the result of last request is assigned
      if (index == requestCount && !nothingView && this.mounted) setState(() => members = suggestedMembers);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    } finally {
      if (index == requestCount && this.mounted) setState(() => isLoading = false);
    }
  }

  void showAddRecipientBtn(String val) {}

  void onSelectMember(String email) {
    backToFirstMode();
    emails.add(email);
    setState(() {});
  }

  void removeEmail(String email) {
    emails.remove(email);
    setState(() {});
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (emails.isNotEmpty) _buildEmailList(),
                    _buildTextField(),
                    _buildLoadingIndicator(),
                    if (members != null) _buildSuggestedMemberList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: const Text('No suggestions', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        if (members.isNotEmpty)
          ...members
              .map((m) => ListTile(
                    trailing: MemberAvatar(color: widget.color, displayName: m.displayName, photoUrl: m.photoUrl),
                    title: Text(m.displayName, overflow: TextOverflow.ellipsis),
                    subtitle: Text(m.email, overflow: TextOverflow.ellipsis),
                    onTap: () => onSelectMember(m.email),
                  ))
              .toList(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 4,
      child: (isLoading)
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(widget.color),
              backgroundColor: widget.color.withOpacity(0.5),
            )
          : Divider(color: widget.color, height: 0.5),
    );
  }

  Widget _buildTextField() {
    return Builder(
      builder: (context) {
        return TextField(
          autofocus: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            labelText: 'Name or email address',
            hasFloatingPlaceholder: false,
          ),
          onChanged: (val) => onInputChange(val, context),
        );
      },
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
            onPressed: !areEmailsValid ? null : () {},
          ),
        ),
      ],
    );
  }
}
