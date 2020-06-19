import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationObserver {
  static NotificationObserver _instance;

  final FirebaseMessaging _messageInstance = FirebaseMessaging();

  factory NotificationObserver() {
    _instance ??= NotificationObserver._internal();
    return _instance;
  }

  Future<void> signIn(String uid) {
    return _messageInstance.subscribeToTopic(uid);
  }

  Future<void> signOut(String uid) {
    return _messageInstance.unsubscribeFromTopic(uid);
  }

  NotificationObserver._internal() {
    _messageInstance.requestNotificationPermissions();
    _messageInstance.configure(onMessage: (Map<String, dynamic> map) {
      print(map['data']);
      Map<String, String> data = map["data"];
      String type = data["type"];

      if (type == "CLASSROOM_DELETED" || type == "ROLE_CHANGE" || type == "KICKED") {
        String classroomId = data["classroomId"];
        // TODO:
      }
      if (type == "INVITATION") {
        String notificationId = data["notificationId"];
        String message = map["notification"]["body"];
        // TODO:
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
