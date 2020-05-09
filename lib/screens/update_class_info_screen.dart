import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/about_class_area.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/info_settings_area.dart';
import 'package:justclass/widgets/opaque_progress_indicator.dart';
import 'package:justclass/widgets/update_class_info_button.dart';
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
  final _updateBtn = GlobalKey<UpdateClassInfoButtonState>();
  bool _loading = false;

  @override
  void initState() {
    _setUpData(widget.cls);

    super.initState();
  }

  void _setUpData(Class cls) {
    _color = Themes.forClass(widget.cls.theme).primaryColor;

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
    isInputSimilarToData() ? Navigator.of(context).pop() : _showLoadingSpin();
    try {
      _updateBtn.currentState.changeState(false);
      final uid = Provider.of<Auth>(context, listen: false).user.uid;
      await widget.cls.updateDetails(uid, input);
      Navigator.of(context).pop();
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    } finally {
      _hideLoadingSpin();
      _updateBtn.currentState.changeState(true);
    }
  }

  void _showLoadingSpin() {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
  }

  void _hideLoadingSpin() {
    if (this.mounted) setState(() => _loading = false);
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
        backgroundColor: _color,
        appBar: _buildTopBar(),
        body: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      AboutClassArea(
                          data: data,
                          input: input,
                          changeUpdateBtnState: (val) => _updateBtn.currentState.changeState(val)),
                      const SizedBox(height: 5),
                      Divider(),
                      const SizedBox(height: 10),
                      InfoSettingsArea(theme: data.theme, input: input),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Visibility(visible: _loading, child: OpaqueProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _color,
      leading: AppIconButton(
        tooltip: 'Cancel',
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        UpdateClassInfoButton(key: _updateBtn, updateClassDetails: _updateClassDetails),
      ],
    );
  }
}
