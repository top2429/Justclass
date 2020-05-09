import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:justclass/providers/class.dart';
import 'package:justclass/providers/class_manager.dart';
import 'package:justclass/widgets/app_snack_bar.dart';
import 'package:justclass/widgets/class_list_view_tile_collaborator.dart';
import 'package:justclass/widgets/class_list_view_tile_student.dart';
import 'package:justclass/widgets/class_list_view_tile_owner.dart';
import 'package:justclass/widgets/refreshable_error_prompt.dart';
import 'package:justclass/widgets/fetch_progress_indicator.dart';

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
  bool _hasError = false;
  bool _didFirstLoad = false;

  set viewType(ViewType type) => setState(() => _type = type);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
    super.initState();
  }

  Future<void> _onRefresh() async {
    try {
      await Provider.of<ClassManager>(context, listen: false).fetchClassList();
      setState(() {
        _didFirstLoad = true;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _didFirstLoad = true;
        _hasError = true;
      });
      AppSnackBar.showError(context, message: error.toString());
    }
  }

  Future<void> _onRefreshAfterFirstLoad() async {
    try {
      await Provider.of<ClassManager>(context, listen: false).fetchClassList();
    } catch (error) {
      AppSnackBar.showError(context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_didFirstLoad) {
      return FetchProgressIndicator();
    }
    if (_hasError) {
      return RefreshableErrorPrompt(onRefresh: _onRefresh);
    }
    return RefreshIndicator(
      onRefresh: _onRefreshAfterFirstLoad,
      child: Consumer<ClassManager>(
        builder: (_, classMgr, __) {
          final classes = classMgr.getClassesOnViewType(_type);
          return ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              Text('${_type.name}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
  }

  Widget _buildTile(ClassRole role) {
    switch (role) {
      case ClassRole.OWNER:
        return ClassListViewTileOwner(context: context);
      case ClassRole.COLLABORATOR:
        return ClassListViewTileCollaborator();
      case ClassRole.STUDENT:
      default:
        return ClassListViewTileStudent();
    }
  }
}
