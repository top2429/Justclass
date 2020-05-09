import 'package:flutter/material.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/utils/validator.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

class UpdateClassInfoScreen extends StatefulWidget {
  final Class cls;

  UpdateClassInfoScreen({this.cls});

  @override
  _UpdateClassInfoScreenState createState() => _UpdateClassInfoScreenState();
}

class _UpdateClassInfoScreenState extends State<UpdateClassInfoScreen> {
  Color _color;
  ClassDetailsData data;
  ClassDetailsData input;
  bool _isValid = true;

  @override
  void initState() {
    _color = Themes.forClass(widget.cls.theme).primaryColor;
    _setUpData(widget.cls);

    super.initState();
  }

  void _setUpData(Class cls) {
    data = ClassDetailsData(
      title: cls.title,
      subject: cls.subject,
      section: cls.section,
      room: cls.room,
      description: cls.description,
      permissionCode: cls.permissionCode,
      theme: cls.theme,
    );
    input = ClassDetailsData(
      title: cls.title,
      subject: cls.subject,
      section: cls.section,
      room: cls.room,
      description: cls.description,
      permissionCode: cls.permissionCode,
      theme: cls.theme,
    );
  }

  void _updateClassDetails(BuildContext context) async {
    if (isInputSimilarToData()) Navigator.of(context).pop();
    try {
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      await widget.cls.updateDetails(uid, input);
      Navigator.of(context).pop();
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    }
  }

  bool isInputSimilarToData() {
    if (input.title != data.title ||
        input.subject != data.subject ||
        input.section != data.section ||
        input.room != data.room ||
        input.description != data.description ||
        input.theme != data.theme ||
        input.permissionCode != data.permissionCode) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: <Widget>[
              // About Area
              Text('About', style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 25)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  initialValue: data.title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  onChanged: (val) {
                    input.title = val;
                    if (_isValid != (CreateClassValidator.validateClassTitle(val) == null)) {
                      setState(() => _isValid = !_isValid);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  initialValue: data.subject,
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
                  initialValue: data.section,
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
                  initialValue: data.room,
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
                  initialValue: data.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (val) => input.description = val,
                ),
              ),
              const SizedBox(height: 10),

              // Settings Area
              Text('Settings', style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 25)),
            ],
          ),
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
        Builder(builder: (context) {
          return Container(
            width: 110,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: FlatButton(
              disabledColor: Colors.grey,
              color: _color,
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: !_isValid ? null : () => _updateClassDetails(context),
            ),
          );
        }),
      ],
    );
  }
}
