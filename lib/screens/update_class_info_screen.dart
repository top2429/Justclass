import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/utils/validator.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/info_settings_area.dart';
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

  void onChangeTheme(int theme) {
    setState(() => input.theme = theme);
  }

  @override
  Widget build(BuildContext context) {
    final padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 20);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: _color,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  // About Area
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      'About',
                      style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      initialValue: data.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _color, width: 2),
                        ),
                      ),
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
                    padding: padding,
                    child: TextFormField(
                      initialValue: data.subject,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _color, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (val) => input.subject = val,
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      initialValue: data.section,
                      decoration: InputDecoration(
                        labelText: 'Section',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _color, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (val) => input.section = val,
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      initialValue: data.room,
                      decoration: InputDecoration(
                        labelText: 'Room',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _color, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      onChanged: (val) => input.room = val,
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: TextFormField(
                      initialValue: data.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _color, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (val) => input.description = val,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Divider(),
                  const SizedBox(height: 10),

                  // Settings Area
                  InfoSettingsArea(themeIndex: input.theme, onChangeTheme: onChangeTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _color,
      leading: AppIconButton(
        tooltip: 'Cancel',
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: AppIconButton(
              icon: Icon(Icons.save),
              onPressed: !_isValid ? null : () => _updateClassDetails(context),
            ),
          );
        }),
      ],
    );
  }
}
