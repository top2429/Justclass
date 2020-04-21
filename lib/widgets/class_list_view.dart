import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/class_list_view_tile_collaborator.dart';
import 'package:justclass/widgets/class_list_view_tile_student.dart';
import 'package:justclass/widgets/class_list_view_tile_owner.dart';
import 'package:justclass/widgets/fetch_error_icon.dart';
import 'package:justclass/widgets/fetch_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'once_future_builder.dart';

enum ViewType { ALL, CREATED, JOINED, COLLABORATING }

extension ViewTypes on ViewType {
  String get name {
    switch (this) {
      case ViewType.ALL:
        return 'All Classes';
      case ViewType.CREATED:
        return 'Created';
      case ViewType.JOINED:
        return 'Joined';
      case ViewType.COLLABORATING:
        return 'Collaborating';
      default:
        return '';
    }
  }
}

class ClassListView extends StatefulWidget {
  ClassListView({Key key}) : super(key: key);

  @override
  ClassListViewState createState() => ClassListViewState();
}

class ClassListViewState extends State<ClassListView> {
  ViewType _type = ViewType.ALL;

  set viewType(ViewType type) => setState(() => _type = type);

  @override
  Widget build(BuildContext context) {
    return OnceFutureBuilder(
      future: Provider.of<ClassManager>(context, listen: false).fetchData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return FetchProgressIndicator();
        if (snapshot.hasError) return FetchErrorPrompt();
        return RefreshIndicator(
          color: Themes.primaryColor,
          onRefresh: () async {
            try {
              await Provider.of<ClassManager>(context, listen: false).fetchData();
            } catch (error) {
              AppSnackBar.showError(context, message: error.toString());
            }
          },
          child: Consumer<ClassManager>(
            builder: (_, classMgr, __) {
              final classes = classMgr.getClassesOnViewType(_type);
              return ListView(
                padding: const EdgeInsets.all(10),
                children: <Widget>[
                  Text('${_type.name}', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                  const Divider(indent: 50, endIndent: 50),
                  ...classes
                      .map((cls) => ChangeNotifierProvider.value(
                            value: cls,
                            child: _buildTile(cls.role),
                          ))
                      .toList()
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTile(ClassRole role) {
    switch (role) {
      case ClassRole.OWNER:
        return ClassListViewTileOwner();
      case ClassRole.TEACHER:
        return ClassListViewTileCollaborator();
      case ClassRole.STUDENT:
        return ClassListViewTileStudent();
      case ClassRole.NOBODY:
      default:
        return Container();
    }
  }
}
