import 'package:flutter/foundation.dart';
import 'package:justclass/models/notification.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:justclass/widgets/app_snack_bar.dart';

class NotificationManager extends ChangeNotifier {
  String _uid;
  List<Notification> _notifications;

  String get uid => _uid;

  List<Notification> get notifications => _notifications;

  bool firstLoadSucceeded;

  set uid(String uid) {
    this._uid = uid;
    this._fetchNotificationListFirstLoad();
  }

  Future<void> _fetchNotificationListFirstLoad() async {
    try {
      _notifications = await ApiCall.getNotificationList(_uid);
      firstLoadSucceeded = true;
    } catch (error) {
      AppSnackBar.showError(null, message: error.toString());
      firstLoadSucceeded = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNotificationList() async {
    try {
      _notifications = await ApiCall.getNotificationList(_uid);
      firstLoadSucceeded = true;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> acceptInvitation(String notificationId) async {
    try {
      await ApiCall.acceptInvitation(uid, notificationId);
      this._notifications.firstWhere((n) => n.notificationId == notificationId)
        ..others['invitationStatus'] = 'ACCEPTED';
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
