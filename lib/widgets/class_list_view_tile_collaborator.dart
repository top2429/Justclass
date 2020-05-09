import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/class_screen.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class ClassListViewTileCollaborator extends StatelessWidget {
  final BuildContext context;

  ClassListViewTileCollaborator({@required this.context});

  static const _radius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Consumer<Class>(
        builder: (_, cls, child) {
          final studentCount = cls.studentCount;
          final countStr = studentCount == 1 ? '$studentCount student' : '$studentCount students';

          return Stack(
            children: <Widget>[
              Container(
                height: 130,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: _radius,
                  child: Hero(
                    tag: 'background${cls.cid}',
                    child: Image.asset(Themes.forClass(cls.theme).imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  borderRadius: _radius,
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.black12,
                    borderRadius: _radius,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClassScreen(cls: cls)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: DefaultTextStyle.merge(
                              style: const TextStyle(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    cls.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    cls.subject,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Text(countStr, style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: PopupMenuButton(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
          icon: const Icon(Icons.more_vert, color: Colors.white),
          offset: const Offset(0, 40),
          itemBuilder: (_) => [
            const PopupMenuItem(child: Text('Edit'), value: 'edit', height: 40),
            const PopupMenuItem(child: Text('Leave'), value: 'leave', height: 40),
          ],
          onSelected: (val) {},
        ),
      ),
    );
  }
}
