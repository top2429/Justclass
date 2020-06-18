import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justclass/models/notification.dart';
import 'package:justclass/models/notification.dart' as app;
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/notification_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'fetch_progress_indicator.dart';
import 'refreshable_error_prompt.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  static const double padding = 15;

  Future<void> fetchMemberList(String uid) async {
    try {
      await Provider.of<NotificationManager>(context, listen: false).fetchNotificationList();
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

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
          ...notMgr.notifications.map((n) => buildInvitationTile(n)).toList(),
        ],
      ),
    );
  }

  Widget buildInvitationTile(app.Notification n) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Container(
      margin: isPortrait
          ? const EdgeInsets.symmetric(vertical: 6, horizontal: 15)
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.7),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          buildNoteTopBar(n.invoker, n.invokeTime),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: buildNotificationContent(n),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildNoteTopBar(User invoker, num time) {
    return ListTile(
      leading: MemberAvatar(
        photoUrl: invoker.photoUrl,
        displayName: invoker.displayName,
        color: Themes.primaryColor,
      ),
      title: Text(
        invoker.displayName,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        DateFormat('HH mm  MMM d yyyy').format(DateTime.fromMillisecondsSinceEpoch(time)),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget buildNotificationContent(app.Notification n) {
    switch (n.notificationType) {
      case NotificationType.INVITATION:
        return Column(
          children: <Widget>[
            Text('Invited'),
            n.others['invitationStatus'] == 'PENDING'
                ? Container(
                    child: OutlineButton(
                      child: Text('Accept'),
                      onPressed: () {},
                    ),
                  )
                : Container(),
          ],
        );
      case NotificationType.ROLE_CHANGE:
        return Text('role changed');
      case NotificationType.KICKED:
        return Text('kicked');
      case NotificationType.CLASSROOM_DELETED:
        return Text('Deleted');
      case NotificationType.OTHERS:
      default:
        return Container();
    }
  }
}
