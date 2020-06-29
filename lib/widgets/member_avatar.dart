import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String photoUrl;
  final String displayName;
  final Color color;

  // add this to the photoURL to create a new URL so that Image.network() will refresh
  final int num;

  const MemberAvatar({this.photoUrl, this.displayName, this.color, this.num});

  @override
  Widget build(BuildContext context) {
    var newUrl = photoUrl;
    if (photoUrl != null && num != null) newUrl += '?justclass=$num';

    return photoUrl == null
        ? SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: color,
              child: Text(displayName[0].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        : ClipOval(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.network(
                newUrl,
                fit: BoxFit.cover,
                gaplessPlayback: false,
              ),
            ),
          );
  }
}
