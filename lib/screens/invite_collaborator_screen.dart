import 'package:flutter/material.dart';
import 'package:justclass/providers/member_manager.dart';
import 'package:justclass/widgets/app_icon_button.dart';

class InviteCollaboratorScreen extends StatefulWidget {
  final MemberManager memberMgr;
  final Color color;

  InviteCollaboratorScreen({@required this.memberMgr, @required this.color});

  @override
  _InviteCollaboratorScreenState createState() => _InviteCollaboratorScreenState();
}

class _InviteCollaboratorScreenState extends State<InviteCollaboratorScreen> {
  final emails = Set<String>();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: _buildTopBar(context, widget.color, 'Invite teachers'),
      floatingActionButton: SizedBox(height: 50),
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
                    Padding(
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
                        onChanged: (val) {},
                      ),
                    ),
                    SizedBox(
                      height: 4,
                      child: (isLoading)
                          ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(widget.color),
                              backgroundColor: widget.color.withOpacity(0.5),
                            )
                          : Divider(color: widget.color),
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
      title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17)),
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
