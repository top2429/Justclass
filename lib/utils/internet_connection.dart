import 'dart:async';

import 'package:connectivity/connectivity.dart';

class InternetConnection {
  factory InternetConnection() {
    _singleton ??= InternetConnection._();
    return _singleton;
  }

  InternetConnection._();

  static InternetConnection _singleton;

  StreamSubscription<ConnectivityResult> _subscription;

  Future<bool> isConnected() async {
    final result = await (Connectivity().checkConnectivity());
    return result != ConnectivityResult.none;
  }

  void subscribe({Function onConnected, Function onLost}) {
    if (_subscription != null) _subscription.cancel();

    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none)
        onLost();
      else
        onConnected();
    });
  }
}
