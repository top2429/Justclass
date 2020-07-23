import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/providers/notification_manager.dart';
import 'package:justclass/screens/notification_screen.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class NotificationObserver {
  static final NotificationObserver _instance = NotificationObserver._internal();

  factory NotificationObserver() => _instance;

  final FirebaseMessaging _messageInstance = FirebaseMessaging();

  Future<void> signIn(String uid) async {
    print('FCM subscribed');
    await _messageInstance.subscribeToTopic(uid);
  }

  Future<void> signOut(String uid) async {
    print('FCM unsubscribed');
    await _messageInstance.unsubscribeFromTopic(uid);
  }

  NotificationObserver._internal() {
    _messageInstance.configure(
      onMessage: (Map<String, dynamic> mes) async {
        final data = mes['data'];
        final type = data['type'];
        final title = data['title'];
        final cid = data["classroomId"];

        if (type == "INVITATION") {
          AppSnackBar.showClassInvitationNotification(
            null,
            begin: 'You have been invited to the class ',
            middle: title,
            end: ' as a ${data['role'].toString().toLowerCase()}.',
          );
        }
        if (type == "CLASSROOM_DELETED") {
          await onRemoveClassAndPopOutOfClassScreen(cid);
          AppSnackBar.showClassWarningNotification(
            null,
            begin: 'The class ',
            middle: title,
            end: ' has been deleted.',
          );
        }
        if (type == "KICKED") {
          await onRemoveClassAndPopOutOfClassScreen(cid);
          AppSnackBar.showClassWarningNotification(
            null,
            begin: 'You have got removed from the class ',
            middle: title,
            end: '.',
          );
        }
        if (type == "ROLE_CHANGE") {}

        Provider.of<NotificationManager>(AppContext.last, listen: false).fetchNotificationList();
      },
      onResume: (Map<String, dynamic> message) async {
        await Future.delayed(const Duration(milliseconds: 100));
        Provider.of<NotificationManager>(AppContext.last, listen: false).fetchNotificationList();
        if (!AppContext.name.contains(NotificationScreen.routeName)) {
          Navigator.of(AppContext.last).push(MaterialPageRoute(builder: (_) => NotificationScreen()));
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        await Future.delayed(const Duration(milliseconds: 300));
        Provider.of<NotificationManager>(AppContext.last, listen: false).fetchNotificationList();
        Navigator.of(AppContext.last).push(MaterialPageRoute(builder: (_) => NotificationScreen()));
      },
    );
  }

  Future<void> onRemoveClassAndPopOutOfClassScreen(String cid) async {
    Provider.of<ClassManager>(AppContext.last, listen: false).removeClassAtOnce(cid);
    if (AppContext.name.contains(cid)) {
      Navigator.popUntil(AppContext.last, (route) => route.isFirst);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}

//      {
//        notification: {
//          title: 'Dancing 101',
//          body: 'You were remove by [HIEU.PV0054 2170054].'
//        },
//        data: {
//            subject: '',
//            type: 'KICKED',
//            title: 'Dancing 101',
//            classroomId: 'QgsIvSxJUAlB8StaoEvv',
//            notificationId: 'zwAsa0LPMuHmb2z3rPyT',
//            invokerName: 'HIEU.PV0054 2170054',
//            invokeTime: 1592645680932
//        }
//      }
