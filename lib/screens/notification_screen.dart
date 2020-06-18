import 'package:flutter/material.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/widgets/notification_list.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'notification-name';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  BuildContext screenCtx;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AppContext.add(screenCtx, NotificationScreen.routeName));
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
      floatingActionButton: const SizedBox(height: 50),
      body: SafeArea(
        child: ClipRRect(
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            color: Colors.white,
            height: double.infinity,
            child: NotificationList(),
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
      title: const Text('Notifications', style: TextStyle(fontSize: 17)),
    );
  }
}
