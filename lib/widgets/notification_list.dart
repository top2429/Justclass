import 'package:flutter/material.dart';
import 'package:justclass/providers/notification_manager.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'fetch_progress_indicator.dart';
import 'refreshable_error_prompt.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool hasError = false;
  bool didFirstLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMemberListFirstLoad(String uid) async {}

  Future<void> fetchMemberList(String uid) async {}

  @override
  Widget build(BuildContext context) {
    final notMgr = Provider.of<NotificationManager>(context);

    if (notMgr.firstLoadSucceeded == null) {
      return FetchProgressIndicator(color: Themes.primaryColor);
    }
    return (!notMgr.firstLoadSucceeded)
        ? RefreshableErrorPrompt(onRefresh: () => fetchMemberList(notMgr.uid))
        : buildNotificationList(notMgr);
  }

  Widget buildNotificationList(NotificationManager notMgr) {
    return RefreshIndicator(
      color: Themes.primaryColor,
      onRefresh: () => fetchMemberList(notMgr.uid),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          ...notMgr.notifications
              .map((n) => ListTile(
                    title: Text(n.classTitle),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
