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

class ClassScreen extends StatelessWidget {
  static const routeName = '/class';
  final Class cls; // cls is class, because class is a keyword in Dart so I cannot use it

  ClassScreen({@required this.cls});

//  final testCls = Class(
//    cid: '0',
//    title: 'KTPM_1234',
//    publicCode: '010ax31',
//    role: ClassRole.OWNER,
//    theme: 5,
//    studentCount: 12,
//    section: 'Môn: Kiến trúc phần mềm',
//  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cls,
      child: Consumer<Class>(
        builder: (_, cls, child) => Scaffold(
          backgroundColor: Themes.forClass(cls.theme).primaryColor,
          body: child,
        ),
        child: ScaleDrawerWrapper(
          drawerContent: HomeDrawerContent(),
          topScaffold: Scaffold(
            backgroundColor: Colors.transparent,
            body: ClassScreenContent(),
          ),
        ),
      ),
    );
  }
}

class ClassScreenContent extends StatefulWidget {
  @override
  _ClassScreenContentState createState() => _ClassScreenContentState();
}

class _ClassScreenContentState extends State<ClassScreenContent> {
  int _index = 0;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return NoteScreen();
      case 1:
        return TopicScreen();
      case 2:
        return MemberScreen();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: <Widget>[
        _getScreen(_index),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Consumer<Class>(
            builder: (_, cls, __) => CurvedNavigationBar(
              color: Themes.forClass(cls.theme).primaryColor,
              height: isPortrait ? 55 : 50,
              backgroundColor: Colors.transparent,
              animationDuration: const Duration(milliseconds: 500),
              index: _index,
              onTap: (index) => setState(() => _index = index),
              items: [
                const Icon(Icons.speaker_notes, color: Colors.white),
                const Icon(Icons.class_, color: Colors.white),
                const Icon(Icons.people, color: Colors.white),
              ],
            ),
          ),
        )
      ],
    );
  }
}
