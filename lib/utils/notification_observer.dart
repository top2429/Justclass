import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/screens/home_screen.dart';
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
        final data = mes['data'];
        final type = data['type'];
        final title = data['title'];
        final cid = data["classroomId"];

        if (type == "INVITATION") {
          AppSnackBar.showSuccess(null, message: 'You are invited to the class $title.');
        }
        if (type == "CLASSROOM_DELETED") {
          await onRemoveClassAndPopOutOfClassScreen(cid);
          AppSnackBar.showClassWarningNotification(
            null,
            content: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'The class '),
                  TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  const TextSpan(text: ' has been deleted.'),
                ],
              ),
            ),
          );
        }
        if (type == "KICKED") {
          await onRemoveClassAndPopOutOfClassScreen(cid);
          AppSnackBar.showClassWarningNotification(
            null,
            content: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'You are removed from the class '),
                  TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: '.'),
                ],
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          );
        }
        if (type == "ROLE_CHANGE") {}
      },
    );
  }

  Future<void> onRemoveClassAndPopOutOfClassScreen(String cid) async {
    //class code: 3484385f
    Provider.of<ClassManager>(AppContext.last, listen: false).removeClassAtOnce(cid);
    if (AppContext.name.contains(cid)) {
      Navigator.popUntil(AppContext.last, (route) => route.isFirst);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
