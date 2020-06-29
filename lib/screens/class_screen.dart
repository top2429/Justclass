import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/note_screen.dart';
import 'package:justclass/screens/topic_screen.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/utils/constants.dart';
import 'package:justclass/widgets/home_drawer_content.dart';
import 'package:justclass/widgets/scale_drawer_wrapper.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import 'member_screen.dart';

class ClassScreen extends StatefulWidget {
  static const routeName = 'class-screen';
  final Class cls; // cls is class, since class is a keyword in Dart so I cannot use it

  ClassScreen({@required this.cls});

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  BuildContext screenCtx;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => AppContext.add(screenCtx, '${ClassScreen.routeName} ${widget.cls.cid}'));
    super.initState();
  }

  @override
  void dispose() {
    AppContext.pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.cls,
      child: Consumer<Class>(
        builder: (_, cls, child) => Scaffold(
          backgroundColor: Themes.forClass(cls.theme).primaryColor,
          body: child,
        ),
        child: Builder(builder: (context) {
          screenCtx = context;
          return ScaleDrawerWrapper(
            drawerContent: HomeDrawerContent(),
            topScaffold: Scaffold(
              backgroundColor: Colors.transparent,
              body: ClassScreenContent(),
            ),
          );
        }),
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
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Stack(
      children: <Widget>[
        PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            NoteScreen(),
            TopicScreen(),
            MemberScreen(),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Consumer<Class>(
            builder: (_, cls, __) => CurvedNavigationBar(
              color: Themes.forClass(cls.theme).primaryColor,
              height: isPortrait ? bottomBarPortraitHeight : bottomBarLandscapeHeight,
              backgroundColor: Colors.transparent,
              animationDuration: const Duration(milliseconds: 500),
              index: _index,
              onTap: (index) => _pageController.jumpToPage(index),
              items: [
                const Icon(Icons.chat_bubble, color: Colors.white),
                const Icon(Icons.collections_bookmark, color: Colors.white),
                const Icon(Icons.people, color: Colors.white),
              ],
            ),
          ),
        )
      ],
    );
  }
}
