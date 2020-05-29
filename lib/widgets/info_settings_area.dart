import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justclass/models/class_details_data.dart';
import 'package:justclass/providers/auth.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class InfoSettingsArea extends StatefulWidget {
  final int theme;
  final ClassDetailsData input;
  final Function resetClassCode;

  InfoSettingsArea({this.theme, this.input, this.resetClassCode});

  @override
  _InfoSettingsAreaState createState() => _InfoSettingsAreaState();
}

class _InfoSettingsAreaState extends State<InfoSettingsArea> {
  int inputTheme;

  @override
  void initState() {
    inputTheme = widget.theme;
    super.initState();
  }

  void _resetClassCode(BuildContext context) async {
    final uid = Provider.of<Auth>(context, listen: false).user.uid;
    try {
      final code = await widget.resetClassCode(uid);
      setState(() => widget.input.classCode = code);
    } catch (error) {
      if (this.mounted) AppSnackBar.showError(context, message: error.toString());
    }
  }

  void _onPickTheme(BuildContext context) async {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    );

    final newTheme = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xff737373),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: _buildThemeList(context),
            ),
          ),
        );
      },
    );
    if (newTheme != null && newTheme != inputTheme) {
      widget.input.theme = newTheme;
      setState(() => inputTheme = newTheme);
    }
  }

  Widget _buildThemeList(BuildContext context) {
    return ListView.builder(
      itemCount: Themes.classThemes.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        final themeImage = ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Image.asset(Themes.classThemes[index].imageUrl, fit: BoxFit.cover),
        );
        if (index == inputTheme) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(index),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  themeImage,
                  Positioned(top: 5, left: 5, child: const Icon(Icons.radio_button_checked, color: Colors.white))
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(index),
          child: Padding(padding: const EdgeInsets.all(5), child: themeImage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            'Settings',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Themes.forClass(widget.theme).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _onPickTheme(context);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 20),
              title: Text('Theme Collection'),
              subtitle: Text('Theme ${inputTheme + 1}'),
              trailing: Container(
                width: 150,
                height: 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: Image.asset(
                    Themes.forClass(inputTheme).imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.input.classCode));
            Scaffold.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 2,
              backgroundColor: Themes.forClass(widget.theme).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Class code copied.'),
            ));
          },
          contentPadding: const EdgeInsets.only(left: 20),
          title: Text('Class Code'),
          subtitle: Text(widget.input.classCode),
          trailing: PopupMenuButton(
            tooltip: 'Code Settings',
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            offset: const Offset(0, 40),
            itemBuilder: (_) {
              return [
                PopupMenuItem(child: Text('Reset class code'), height: 40, value: 'reset'),
              ];
            },
            onSelected: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              if (val == 'reset') _resetClassCode(context);
            },
          ),
        )
      ],
    );
  }
}
