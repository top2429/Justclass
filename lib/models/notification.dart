import 'package:justclass/models/user.dart';

enum NotificationType { INVITATION, ROLE_CHANGE, UNDEFINED }

extension NotificationTypes on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.INVITATION:
        return 'INVITATION';
      case NotificationType.ROLE_CHANGE:
        return 'ROLE_CHANGE';
      default:
        return 'UNDEFINED';
    }
  }

  static NotificationType getType(String code) {
    if (code == 'INVITATION')
      return NotificationType.INVITATION;
    else if (code == 'ROLE_CHANGE')
      return NotificationType.ROLE_CHANGE;
    else
      return NotificationType.UNDEFINED;
  }
}

class Notification {
  String notificationId;
  String cid;
  String classSubject;
  String classTitle;
  NotificationType notificationType;
  User invoker;
  int invokeTime;
  Map<String, dynamic> others;

  Notification.fromJson(dynamic json) {
    this.notificationId = json['notificationId'];
    this.cid = json['classroom']['classroomId'];
    this.classSubject = json['classroom']['subject'];
    this.classTitle = json['classroom']['title'];

    if (json['invoker'] != null)
      this.invoker = User(
        uid: json['invoker']['localId'],
        email: json['invoker']['email'],
        photoUrl: json['invoker']['photoUrl'],
        displayName: json['invoker']['displayName'],
      );

    invokeTime = json['invokeTime'];
    if (json['notificationType'] == 'INVITATION') {
      notificationType = NotificationType.INVITATION;
      others['invitationStatus'] = json['invitationStatus'];
    }
    if (json['notificationType'] == 'ROLE_CHANGE') {
      notificationType = NotificationType.ROLE_CHANGE;
    }
  }
}
