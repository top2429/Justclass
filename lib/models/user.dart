import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;

  const User({
    @required this.id,
    @required this.email,
    @required this.displayName,
    this.photoUrl,
  });
}
