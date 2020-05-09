import 'package:flutter/material.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/class_list_view.dart';
import 'package:justclass/widgets/create_class_button.dart';
import 'package:justclass/widgets/home_backdrop_scaffold.dart';
import 'package:justclass/widgets/home_drawer_content.dart';
import 'package:justclass/widgets/join_class_button.dart';
import 'package:justclass/widgets/scale_drawer_wrapper.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final _drawer = GlobalKey<ScaleDrawerWrapperState>();
  final _classListView = GlobalKey<ClassListViewState>();
  final _backdropScaffold = GlobalKey<HomeBackdropScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double dropDistance = isPortrait ? 230 : 200;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Themes.primaryColor,
      body: ScaleDrawerWrapper(
        key: _drawer,
        drawerContent: HomeDrawerContent(),
        topScaffold: HomeBackdropScaffold(
          key: _backdropScaffold,
          title: const Text("JustClass", style: TextStyle(fontWeight: FontWeight.bold)),
          dropDistance: dropDistance,
          backColor: Theme.of(context).backgroundColor,
          leading: AppIconButton(icon: const Icon(Icons.menu), onPressed: () => _drawer.currentState.swap()),
          actions: <Widget>[_buildPopupMenu()],
          backLayer: LayoutBuilder(
            builder: (_, constraints) {
              final width = isPortrait ? constraints.maxWidth * 0.35 : constraints.maxWidth * 0.3;
              return _buildBackLayer(dropDistance, width);
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
          Container(
            height: height,
            width: width,
            child: Center(child: CreateClassButton(onDidCreateClass: _backdropScaffold.currentState.swap)),
          ),
          Container(
            height: height,
            width: width,
            child: Center(child: JoinClassButton(onDidJoinClass: _backdropScaffold.currentState.swap)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(kToolbarHeight / 2)),
      child: SizedBox(
        width: kToolbarHeight,
        child: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            tooltip: 'Filter',
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            offset: const Offset(0, 40),
            itemBuilder: (_) => [
              const PopupMenuItem(child: Text('Joined'), value: ViewType.JOINED, height: 40),
              const PopupMenuItem(child: Text('Created'), value: ViewType.CREATED, height: 40),
              const PopupMenuItem(child: Text('Collaborating'), value: ViewType.COLLABORATING, height: 40),
              const PopupMenuItem(child: Text('All'), value: ViewType.ALL, height: 40),
            ],
            onSelected: (viewType) => _classListView.currentState.viewType = viewType,
          ),
        ),
      ),
    );
  }
}
