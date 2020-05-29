import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/member_list.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cls = Provider.of<Class>(context);
    final color = Themes.forClass(cls.theme).primaryColor;

    return Scaffold(
      backgroundColor: color,
      appBar: _buildTopBar(context, color, cls.title),
      floatingActionButton: const SizedBox(height: 50),
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

  Widget _buildTopBar(BuildContext context, Color bgColor, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      automaticallyImplyLeading: false,
      title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17)),
      actions: <Widget>[
        AppIconButton(
          icon: const Icon(Icons.extension, size: 22),
          tooltip: 'Role Pass',
          onPressed: () {},
        ),
      ],
    );
  }
}
