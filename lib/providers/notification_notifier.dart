import 'package:flutter/foundation.dart';
import 'package:justclass/models/notification.dart';
import 'package:justclass/utils/api_call.dart';

class NotificationManager extends ChangeNotifier {
  String _uid;
  List<Notification> _notifications;

  String get uid => _uid;

  List<Notification> get notifications => _notifications;

  bool firstLoadSucceeded;

  set uid(String uid) {
    print("set uid");
    this._uid = uid;
    this.fetchNotificationListFirstLoad();
  }

  Future<void> fetchNotificationListFirstLoad() async {
    try {
      _notifications = await ApiCall.getNotificationList(_uid);
      firstLoadSucceeded = true;
      print(123);
    } catch (error) {
      firstLoadSucceeded = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNotificationList() async {
    try {
      _notifications = await ApiCall.getNotificationList(_uid);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
