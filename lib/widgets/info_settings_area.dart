import 'package:flutter/material.dart';

import '../themes.dart';

class InfoSettingsArea extends StatelessWidget {
  final int themeIndex;
  final Function onChangeTheme;

  InfoSettingsArea({this.themeIndex, this.onChangeTheme});

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
    onChangeTheme(newTheme);
  }

  Widget _buildThemeList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: Themes.classThemes.map((theme) {
        if (Themes.classThemes.indexOf(theme) == themeIndex) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(Themes.classThemes.indexOf(theme)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.asset(theme.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(top: 5, left: 5, child: const Icon(Icons.radio_button_checked, color: Colors.white))
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(Themes.classThemes.indexOf(theme)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.asset(theme.imageUrl, fit: BoxFit.cover),
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
              color: Themes.forClass(themeIndex).primaryColor,
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
              subtitle: Text('Theme ${themeIndex + 1}'),
              trailing: Container(
                width: 150,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.asset(
                    Themes.forClass(themeIndex).imageUrl,
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
