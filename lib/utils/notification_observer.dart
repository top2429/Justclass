import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:justclass/widgets/app_snack_bar.dart';

class NotificationObserver {
  static NotificationObserver _instance;

  final FirebaseMessaging _messageInstance = FirebaseMessaging();

  factory NotificationObserver() {
    _instance ??= NotificationObserver._internal();
    return _instance;
  }

  Future<void> signIn(String uid) {
    print('Cloud messaging subscribed');
    return _messageInstance.subscribeToTopic(uid);
  }

  Future<void> signOut(String uid) {
    print('Cloud messaging unsubscribed');
    return _messageInstance.unsubscribeFromTopic(uid);
  }

  NotificationObserver._internal() {
    debugPrint("Notification Observer internal");
    _messageInstance.requestNotificationPermissions();
    _messageInstance.configure(onMessage: (Map<String, dynamic> map) {
      Map<String, String> data = map["data"];
      print(123);
      String type = data["type"];
      String message = map["notification"]["body"];

      if (type == "CLASSROOM_DELETED" || type == "ROLE_CHANGE" || type == "KICKED") {
        debugPrint('123');
//        AppSnackBar.showError(null, message: message);
      }
      if (type == "INVITATION") {
        String notificationId = data["notificationId"];
        debugPrint("invited");
//        AppSnackBar.showSuccess(null, message: message);
      }
      return;
    });
  }

//  {
//    subject: abc,
//    role: COLLABORATOR,
//    type: INVITATION,
//    title: Dancing 101,
//    classroomId: QgsIvSxJUAlB8StaoEvv,
//    notificationId: FC3trPlPcgUpKIPbkl2G,
//    invokerName: HIEU.PV0054 2170054,
//    invokeTime: 1592551111403
//  }
}
