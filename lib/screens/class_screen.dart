import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/note_screen.dart';
import 'package:justclass/screens/topic_screen.dart';
import 'package:justclass/widgets/home_drawer_content.dart';
import 'package:justclass/widgets/scale_drawer_wrapper.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'member_screen.dart';

class ClassScreen extends StatefulWidget {
  static const routeName = '/class';
  final Class cls; // cls is class, because class is a keyword in Dart so I cannot use it

  ClassScreen({@required this.cls});

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final _drawer = GlobalKey<ScaleDrawerWrapperState>();
  int _index = 0;

  final testCls = Class(
    cid: '0',
    title: 'KTPM_1234',
    publicCode: '010ax31',
    role: ClassRole.OWNER,
    theme: 0,
    studentCount: 12,
    section: 'Môn: Kiến trúc phần mềm',
  );

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return NoteScreen();
      case 1:
        return TopicScreen();
      case 2:
        return MemberScreen();
      default:
        return NoteScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return ChangeNotifierProvider(
      create: (_) => testCls,
      child: Consumer<Class>(builder: (_, cls, __) {
        final color = Themes.forClass(cls.theme).primaryColor;
        cls.fetchDetails().then((_) => setState(() {}));

        return Scaffold(
          backgroundColor: color,
          body: ScaleDrawerWrapper(
            key: _drawer,
            drawerContent: HomeDrawerContent(),
            scaffold: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  _getScreen(_index),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CurvedNavigationBar(
                      color: color,
                      height: isPortrait ? 65 : 55,
                      backgroundColor: Colors.transparent,
                      animationDuration: const Duration(milliseconds: 500),
                      index: _index,
                      onTap: (index) => setState(() => this._index = index),
                      items: [
                        Icon(Icons.speaker_notes, color: Colors.white),
                        Icon(Icons.class_, color: Colors.white),
                        Icon(Icons.people, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
