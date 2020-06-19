import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justclass/models/notification.dart';
import 'package:justclass/models/notification.dart' as app;
import 'package:justclass/models/user.dart';
import 'package:justclass/providers/notification_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/member_avatar.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:justclass/widgets/fetch_progress_indicator.dart';
import 'package:justclass/widgets/refreshable_error_prompt.dart';

import '../themes.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  static const double padding = 15;
  bool loading = false;

  Future<void> fetchMemberList(String uid) async {
    try {
      await Provider.of<NotificationManager>(context, listen: false).fetchNotificationList();
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  Future<void> acceptInvitation(String notId) async {
    try {
      setState(() => loading = true);
      await Provider.of<NotificationManager>(context, listen: false).acceptInvitation(notId);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    } finally {
      if (this.mounted) setState(() => loading = false);
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
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              if (notMgr.notifications.length == 0) buildEmptyBoard(),
              const SizedBox(height: 20),
              ...notMgr.notifications.map((n) => buildInvitationTile(n)).toList(),
              const SizedBox(height: 20),
            ],
          ),
          Visibility(visible: loading, child: OpaqueProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildEmptyBoard() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        margin: isPortrait
            ? const EdgeInsets.all(25)
            : EdgeInsets.symmetric(horizontal: constraint.maxWidth * 0.2, vertical: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Themes.primaryColor.withOpacity(0.05),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(isPortrait ? Icons.crop_portrait : Icons.crop_landscape, color: Themes.primaryColor, size: 30),
            const SizedBox(width: 10),
            const Text('Empty Board', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    });
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
          buildNoteTopBar(n.invoker, n.invokeTime),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: buildNotificationContent(n),
          ),
          const SizedBox(height: 15),
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
        DateFormat('HH:mm  MMM d yyyy').format(DateTime.fromMillisecondsSinceEpoch(time)),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget buildNotificationContent(app.Notification n) {
    switch (n.notificationType) {
      case NotificationType.INVITATION:
        final accepted = (n.others['invitationStatus'] == 'ACCEPTED');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'You are invited to the class '),
                  TextSpan(
                    text: n.classTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextSpan(text: ' as a ${n.others['role'].toString().toLowerCase()}.'),
                ],
                style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 7),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: OutlineButton(
                    highlightedBorderColor: Colors.transparent,
//                    borderSide: BorderSide(color: Themes.primaryColor),
                    child: Text(accepted ? 'ACCEPTED' : 'ACCEPT',
                        style: TextStyle(
                          color: accepted ? Colors.grey : Themes.primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: accepted ? null : () => acceptInvitation(n.notificationId),
                  ),
                )),
          ],
        );
      case NotificationType.ROLE_CHANGE:
        // TODO: change later
        return Text('role changed');
      case NotificationType.KICKED:
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(text: 'You have got removed from the class '),
              TextSpan(text: n.classTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              const TextSpan(text: '.'),
            ],
            style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
          ),
        );
      case NotificationType.CLASSROOM_DELETED:
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(text: 'The class '),
              TextSpan(text: n.classTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              const TextSpan(text: ' has been removed.'),
            ],
            style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
          ),
        );
      case NotificationType.OTHERS:
      default:
        return Container();
    }
  }
}
