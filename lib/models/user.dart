import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;

  const User({
    @required this.uid,
    @required this.email,
    @required this.displayName,
    this.photoUrl,
  });
}
