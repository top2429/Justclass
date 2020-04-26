import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class NoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return Scaffold(
      backgroundColor: Themes.forClass(cls.theme).primaryColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: RefreshIndicator(
            onRefresh: () {
              return Future.value(null);
            },
            displacement: 63,
            child: CustomScrollView(
              slivers: <Widget>[
                NoteScreenTopBar(),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 10),
                    buildChangeBtn(context),
                    buildTestNote(context),
                    buildTestNote(context),
                    buildTestNote(context),
                    buildTestNote(context),
                    buildTestNote(context),
                    const SizedBox(height: 70),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTestNote(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Themes.forClass(cls.theme).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(height: 150),
    );
  }

  Widget buildChangeBtn(BuildContext context) {
    final cls = Provider.of<Class>(context);
    return Center(
      child: RaisedButton(
        onPressed: cls.changeTheme,
      ),
    );
  }
}

class NoteScreenTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final cls = Provider.of<Class>(context);
    return SliverAppBar(
      elevation: 5,
      expandedHeight: 130,
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
        AppIconButton(
          tooltip: 'Edit Class Info',
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }
}
