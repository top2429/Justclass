import 'package:flutter/material.dart';
import 'package:justclass/utils/app_context.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'notification-name';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  BuildContext screenCtx;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => AppContext.add(screenCtx, NotificationScreen.routeName));
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
      body: Builder(
        builder: (context) {
          screenCtx = context;
          return Center(
            child: Text('Notifications'),
          );
        },
      ),
    );
  }
}
