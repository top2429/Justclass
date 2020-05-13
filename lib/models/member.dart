import 'package:flutter/foundation.dart';
import 'package:justclass/providers/class.dart';

class Member {
  final String uid;
  final String displayName;
  final String photoUrl;
  final int joinDatetime;
  final ClassRole role;

  Member({
    @required this.uid,
    this.photoUrl,
    @required this.displayName,
    this.joinDatetime,
    this.role,
  });
}
