import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/widgets/app_icon_button.dart';

import '../themes.dart';

class ClassInfoScreen extends StatelessWidget {
  final Class cls;

  ClassInfoScreen({this.cls});

  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(cls.theme).primaryColor;

    return Scaffold(
      backgroundColor: color,
      appBar: _buildTopBar(context, color),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            color: Colors.white,
            height: double.infinity,
            child: Builder(builder: (context) {
              return ListView(
                padding: const EdgeInsets.all(25),
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  _buildTile('Title', cls.title, color),
                  if (cls.subject != null && cls.subject.trim().length > 0) _buildTile('Subject', cls.subject, color),
                  if (cls.room != null && cls.room.trim().length > 0) _buildTile('Room', cls.room, color),
                  if (cls.section != null && cls.section.trim().length > 0) _buildTile('Section', cls.section, color),
                  if (cls.description != null && cls.description.trim().length > 0)
                    _buildTile('Description', cls.description, color),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Color color) {
    return AppBar(
      elevation: 0,
      backgroundColor: color,
      automaticallyImplyLeading: false,
      leading: AppIconButton.back(onPressed: () => Navigator.of(context).pop()),
      title: const Text('Class About', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTile(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color, height: 1.5)),
        const SizedBox(height: 5),
        Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
        const SizedBox(height: 15),
      ],
    );
  }
}
