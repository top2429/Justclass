import 'package:flutter/material.dart';
import 'package:justclass/models/class_details_data.dart';

import '../themes.dart';

class InfoSettingsArea extends StatefulWidget {
  final int theme;
  final ClassDetailsData input;

  InfoSettingsArea({this.theme, this.input});

  @override
  _InfoSettingsAreaState createState() => _InfoSettingsAreaState();
}

class _InfoSettingsAreaState extends State<InfoSettingsArea> {
  int inputTheme;

  initState() {
    inputTheme = widget.theme;

    super.initState();
  }

  _onPickTheme(BuildContext context) async {
    const borderRadius = const BorderRadius.only(
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
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
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
      ],
    );
  }
}
