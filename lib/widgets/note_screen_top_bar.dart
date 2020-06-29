import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/class_info_screen.dart';
import 'package:justclass/screens/update_class_info_screen.dart';
import 'package:justclass/utils/constants.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'app_icon_button.dart';

class NoteScreenTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return SliverAppBar(
      elevation: 3,
      expandedHeight: sliverTopBarHeight,
      forceElevated: true,
      backgroundColor: Themes.forClass(cls.theme).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Hero(
                tag: 'background${cls.cid}',
                child: Image.asset(Themes.forClass(cls.theme).imageUrl, fit: BoxFit.cover),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cls.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (cls.subject.isNotEmpty)
                    Text(
                      cls.subject,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      leading: AppIconButton.back(onPressed: () => Navigator.of(context).pop()),
      actions: <Widget>[
        (cls.role == ClassRole.OWNER)
            ? AppIconButton(
                tooltip: 'Edit Class Info',
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UpdateClassInfoScreen(cls: cls)),
                  );
                },
              )
            : AppIconButton(
                tooltip: 'Class Info',
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ClassInfoScreen(cls: cls)),
                  );
                },
              ),
      ],
    );
  }
}
