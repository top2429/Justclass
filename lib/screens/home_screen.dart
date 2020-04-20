import 'package:flutter/material.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/backdrop_scaffold.dart';
import 'package:justclass/widgets/class_list_view.dart';
import 'package:justclass/widgets/create_class_button.dart';
import 'package:justclass/widgets/home_drawer_content.dart';
import 'package:justclass/widgets/join_class_button.dart';
import 'package:justclass/widgets/scale_drawer_wrapper.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final _drawer = GlobalKey<ScaleDrawerWrapperState>();
  final _classListView = GlobalKey<ClassListViewState>();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final headerHeight = isPortrait ? 400.0 : 100.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Themes.primaryColor,
      body: ScaleDrawerWrapper(
        key: _drawer,
        drawerContent: HomeDrawerContent(),
        scaffold: BackdropScaffold(
          title: const Text("JustClass", style: TextStyle(fontWeight: FontWeight.bold)),
          headerHeight: headerHeight,
          iconPosition: BackdropIconPosition.action,
          appBarColor: Theme.of(context).backgroundColor,
          backLayerColor: Theme.of(context).backgroundColor,
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => _drawer.currentState.swap()),
          actions: <Widget>[_buildPopupMenu()],
          backLayer: LayoutBuilder(
            builder: (_, constraints) {
              final height = constraints.maxHeight - headerHeight;
              final width = isPortrait ? constraints.maxWidth * 0.35 : constraints.maxWidth * 0.3;
              return _buildBackLayer(height, width);
            },
          ),
          frontLayer: ClassListView(key: _classListView),
        ),
      ),
    );
  }

  Widget _buildBackLayer(double height, double width) {
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(height: height, width: width, child: Center(child: CreateClassButton())),
          Container(height: height, width: width, child: Center(child: JoinClassButton())),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      icon: const Icon(Icons.more_vert, color: Colors.white),
      offset: const Offset(0, 40),
      itemBuilder: (_) => [
        const PopupMenuItem(child: Text('Joined'), value: ViewType.JOINED, height: 40),
        const PopupMenuItem(child: Text('Created'), value: ViewType.CREATED, height: 40),
        const PopupMenuItem(child: Text('Collaborating'), value: ViewType.COLLABORATING, height: 40),
        const PopupMenuItem(child: Text('All'), value: ViewType.ALL, height: 40),
      ],
      onSelected: (viewType) => _classListView.currentState.viewType = viewType,
    );
  }
}
