import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/teacher_floating_action_button.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class TopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Themes.forClass(Provider.of<Class>(context).theme);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double distance = isPortrait ? 110 : 100;

    return Scaffold(
      floatingActionButton: TeacherFloatingActionButton(
        bottomDistance: distance,
        primaryColor: theme.primaryColor,
        secondaryColor: theme.secondaryColor,
        actions: <Map<String, dynamic>>[
          {
            'tooltip': 'New Assignment',
            'child': Icon(Icons.assignment),
            'onPressed': () {},
          },
          {
            'tooltip': 'New Material',
            'child': Icon(Icons.attachment),
            'onPressed': () {},
          },
          {
            'tooltip': 'New Topic',
            'child': Icon(Icons.playlist_add),
            'onPressed': () {},
          },
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
