import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/member_list.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Themes.forClass(Provider.of<Class>(context, listen: false).theme).primaryColor;

    return Scaffold(
      backgroundColor: color,
      appBar: _buildTopBar(context, color),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            color: Colors.white,
            height: double.infinity,
            child: MemberList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Color bgColor) {
    final title = Provider.of<Class>(context, listen: false).title;

    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      automaticallyImplyLeading: false,
      title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17)),
      actions: <Widget>[
        AppIconButton(
          icon: Icon(Icons.extension),
          tooltip: 'Role Pass',
          onPressed: () {},
        ),
      ],
    );
  }
}
