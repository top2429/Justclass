import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/screens/teacher_floating_action_button.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class TopicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double distance = isPortrait ? 130 : 100;

    final theme = Provider.of<Class>(context).theme;
    final primaryColor = Themes.forClass(theme).primaryColor;
    final secondaryColor = Themes.forClass(theme).secondaryColor;

    return Scaffold(
      floatingActionButton: TeacherFloatingActionButton(
        bottomDistance: distance,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        actions: <Map<String, dynamic>>[
          {
            'child': Icon(Icons.assignment),
            'onPressed': () {},
          },
          {
            'child': Icon(Icons.attachment),
            'onPressed': () {},
          }
        ],
      ),
    );
  }
}
