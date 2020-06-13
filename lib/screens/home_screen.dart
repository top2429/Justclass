import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justclass/themes.dart';
import 'package:justclass/utils/app_context.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/class_list_view.dart';
import 'package:justclass/widgets/create_class_button.dart';
import 'package:justclass/widgets/home_backdrop_scaffold.dart';
import 'package:justclass/widgets/home_drawer_content.dart';
import 'package:justclass/widgets/join_class_button.dart';
import 'package:justclass/widgets/scale_drawer_wrapper.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext screenCtx;
  final _drawer = GlobalKey<ScaleDrawerWrapperState>();
  final _classListView = GlobalKey<ClassListViewState>();
  final _backdropScaffold = GlobalKey<HomeBackdropScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => AppContext.add(screenCtx, HomeScreen.routeName));
    super.initState();
  }

  @override
  void dispose() {
    AppContext.pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double dropDistance = isPortrait ? 230 : 200;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Themes.primaryColor,
      body: Builder(builder: (context) {
        screenCtx = context;
        return ScaleDrawerWrapper(
          key: _drawer,
          drawerContent: HomeDrawerContent(),
          topScaffold: HomeBackdropScaffold(
            key: _backdropScaffold,
            title: const Text("JustClass", style: TextStyle(fontWeight: FontWeight.bold)),
            dropDistance: dropDistance,
            backColor: Theme.of(context).backgroundColor,
            leading:
                AppIconButton(icon: const Icon(Icons.menu, size: 22), onPressed: () => _drawer.currentState.swap()),
            actions: <Widget>[_buildPopupMenu()],
            backLayer: LayoutBuilder(
              builder: (_, constraints) {
                final width = isPortrait ? constraints.maxWidth * 0.35 : constraints.maxWidth * 0.3;
                return _buildBackLayer(dropDistance, width);
              },
            ),
            frontLayer: ClassListView(key: _classListView),
          ),
        );
      }),
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
            child: Center(child: CreateClassButton(onDidCreateClass: _backdropScaffold.currentState.reserve)),
          ),
          Container(
            height: height,
            width: width,
            child: Center(child: JoinClassButton(onDidJoinClass: _backdropScaffold.currentState.reserve)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    PopupMenuItem appPopupMenuItem(String title, ViewType type) {
      final chosen = _classListView.currentState.viewType == type;

      return PopupMenuItem(
        child: Text(
          title,
          style: TextStyle(
            color: chosen ? Themes.primaryColor : Colors.blueGrey,
            fontWeight: chosen ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        value: type,
        height: 40,
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(kToolbarHeight / 2)),
      child: SizedBox(
        width: kToolbarHeight,
        child: Material(
          color: Colors.transparent,
          child: PopupMenuButton(
            tooltip: 'Filter',
            child: const Icon(Icons.filter_list, size: 22),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            offset: const Offset(0, 40),
            itemBuilder: (_) => [
              appPopupMenuItem('Joined', ViewType.JOINED),
              appPopupMenuItem('Created', ViewType.CREATED),
              appPopupMenuItem('Collaborating', ViewType.COLLABORATING),
              appPopupMenuItem('All', ViewType.ALL),
            ],
            onSelected: (viewType) => _classListView.currentState.viewType = viewType,
          ),
        ),
      ),
    );
  }
}
