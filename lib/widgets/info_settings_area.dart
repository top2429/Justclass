import 'package:flutter/material.dart';

import '../themes.dart';

class InfoSettingsArea extends StatelessWidget {
  final int theme;
  final int inputTheme;
  final Function onChangeTheme;

  InfoSettingsArea({this.theme, this.inputTheme, this.onChangeTheme});

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
    if (newTheme != null && newTheme != inputTheme) onChangeTheme(newTheme);
  }

  Widget _buildThemeList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: Themes.classThemes.map((classTheme) {
        if (Themes.classThemes.indexOf(classTheme) == inputTheme) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(Themes.classThemes.indexOf(classTheme)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.asset(classTheme.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(top: 5, left: 5, child: const Icon(Icons.radio_button_checked, color: Colors.white))
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(Themes.classThemes.indexOf(classTheme)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.asset(classTheme.imageUrl, fit: BoxFit.cover),
            ),
          ),
        );
      }).toList(),
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
              color: Themes.forClass(theme).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => _onPickTheme(context),
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
