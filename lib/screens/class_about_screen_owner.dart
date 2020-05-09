import 'package:flutter/material.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:provider/provider.dart';

class ClassSettingData {
  String title;
  String subject;
  String section;
  String room;
  String description;
  PermissionCode permissionCode;
  int theme;

  ClassSettingData({
    @required this.title,
    @required this.subject,
    @required this.section,
    @required this.room,
    @required this.description,
    @required this.permissionCode,
    @required this.theme,
  });
}

class ClassAboutScreenOwner extends StatefulWidget {
  final Class cls;

  ClassAboutScreenOwner({this.cls});

  @override
  _ClassAboutScreenOwnerState createState() => _ClassAboutScreenOwnerState();
}

class _ClassAboutScreenOwnerState extends State<ClassAboutScreenOwner> {
  Color _color;
  ClassSettingData data;
  ClassSettingData input;

  @override
  void initState() {
    _color = Themes.forClass(widget.cls.theme).primaryColor;
    _setUpData(widget.cls);

    super.initState();
  }

  void _setUpData(Class cls) {
    data = ClassSettingData(
      title: cls.title,
      subject: cls.subject,
      section: cls.section,
      room: cls.room,
      description: cls.description,
      permissionCode: cls.permissionCode,
      theme: cls.theme,
    );
    input = ClassSettingData(
      title: cls.title,
      subject: cls.subject,
      section: cls.section,
      room: cls.room,
      description: cls.description,
      permissionCode: cls.permissionCode,
      theme: cls.theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.cls,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            Text('About', style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 25)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onChanged: (val) => input.title = val,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Subject'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onChanged: (val) => input.subject = val,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Section'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onChanged: (val) => input.section = val,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Room'),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onChanged: (val) => input.room = val,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                onChanged: (val) => input.description = val,
              ),
            ),
            const SizedBox(height: 10),
            Text('Settings', style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 25)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: AppIconButton(
        tooltip: 'Cancel',
        icon: const Icon(Icons.close, color: Colors.grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        Container(
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: RaisedButton(
            elevation: 1,
            color: _color,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
