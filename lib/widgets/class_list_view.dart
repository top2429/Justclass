import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justclass/all_themes.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/class_list_view_tile_assistant.dart';
import 'package:justclass/widgets/class_list_view_tile_student.dart';
import 'package:justclass/widgets/class_list_view_tile_owner.dart';
import 'package:justclass/widgets/fetch_error_icon.dart';
import 'package:justclass/widgets/fetch_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'once_future_builder.dart';

enum Filter { ALL, CREATED, JOINED, ASSISTING }

class ClassListView extends StatelessWidget {
  final Filter viewType;

  const ClassListView({this.viewType});

  @override
  Widget build(BuildContext context) {
    return OnceFutureBuilder(
      future: Provider.of<ClassManager>(context, listen: false).fetchData,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return FetchProgressIndicator();
        if (snapshot.error != null) return FetchErrorPrompt();
        return RefreshIndicator(
          color: AllThemes.primaryColor,
          onRefresh: () async {
            try {
              await Provider.of<ClassManager>(context, listen: false).fetchData();
            } catch (error) {
              AppSnackBar.show(context, message: error.toString());
            }
          },
          child: Consumer<ClassManager>(
            builder: (_, classMgr, __) {
              final classes = classMgr.getClasses(viewType);
              return ListView(
                padding: const EdgeInsets.all(13),
                children: classes
                    .map((c) => ChangeNotifierProvider.value(
                          value: c,
                          child: _buildTile(c.role),
                        ))
                    .toList(),
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
      case ClassRole.ASSISTANT:
        return ClassListViewTileAssistant();
      case ClassRole.STUDENT:
        return ClassListViewTileStudent();
      case ClassRole.NOBODY:
      default:
        return Container();
    }
  }
}
