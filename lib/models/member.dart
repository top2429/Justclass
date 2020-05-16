import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';

class Member {
  final String uid;
  final String displayName;
  final String photoUrl;
  final int joinDatetime;
  final String email;
  final ClassRole role;

  Member({
    @required this.uid,
    @required this.displayName,
    this.email,
    this.photoUrl,
    this.joinDatetime,
    this.role,
  });
}
