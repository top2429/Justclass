import 'package:justclass/models/user.dart';

enum NotificationType { INVITATION, ROLE_CHANGE, KICKED, CLASSROOM_DELETED, OTHERS }

extension NotificationTypes on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.INVITATION:
        return 'INVITATION';
      case NotificationType.ROLE_CHANGE:
        return 'ROLE_CHANGE';
      case NotificationType.KICKED:
        return 'KICKED';
      case NotificationType.CLASSROOM_DELETED:
        return 'CLASSROOM_DELETED';
      default:
        return 'OTHERS';
    }
  }

  static NotificationType getType(String code) {
    if (code == 'INVITATION')
      return NotificationType.INVITATION;
    else if (code == 'ROLE_CHANGE')
      return NotificationType.ROLE_CHANGE;
    else if (code == 'KICKED')
      return NotificationType.KICKED;
    else if (code == 'CLASSROOM_DELETED')
      return NotificationType.CLASSROOM_DELETED;
    else
      return NotificationType.OTHERS;
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

    this.invoker = User(
      uid: json['invoker']['localId'],
      email: json['invoker']['email'],
      photoUrl: json['invoker']['photoUrl'],
      displayName: json['invoker']['displayName'],
    );

    invokeTime = json['invokeTime'];

    this.notificationType = NotificationTypes.getType(json['notificationType']);
    switch (this.notificationType) {
      case NotificationType.INVITATION:
        this.others = {
          'invitationStatus': json['invitationStatus'],
          'role': json['role'],
        };
        break;
      case NotificationType.ROLE_CHANGE:
        this.others = {};
        break;
      case NotificationType.KICKED:
        this.others = {};
        break;
      case NotificationType.CLASSROOM_DELETED:
        this.others = {};
        break;
      case NotificationType.OTHERS:
        // TODO: Handle this case.
        break;
    }
  }
}
