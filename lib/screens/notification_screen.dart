import 'package:flutter/material.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/notification_list.dart';

import '../themes.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'notification-screen';

  final String cid;

  NotificationScreen([this.cid]);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  BuildContext screenCtx;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contextName =
          (widget.cid == null) ? NotificationScreen.routeName : '${NotificationScreen.routeName} ${widget.cid}';
      AppContext.add(screenCtx, contextName);
    });

    super.initState();
  }

  @override
  void dispose() {
    AppContext.pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.primaryColor,
      appBar: _buildTopBar(context),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            color: Colors.white,
            height: double.infinity,
            child: Builder(builder: (context) {
              screenCtx = context;
              return NotificationList();
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Themes.primaryColor,
      automaticallyImplyLeading: false,
      leading: AppIconButton.back(onPressed: () => Navigator.of(context).pop()),
      title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
