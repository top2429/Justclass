import 'package:flutter/material.dart';
import 'package:justclass/widgets/backdrop_scaffold.dart';
import 'package:justclass/widgets/create_class_button.dart';
import 'package:justclass/widgets/join_class_button.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final headerHeight = (orientation == Orientation.portrait) ? 400.0 : 100.0;

    return BackdropScaffold(
      title: const Text("JustClass", style: TextStyle(fontWeight: FontWeight.bold)),
      headerHeight: headerHeight,
      iconPosition: BackdropIconPosition.action,
      appBarColor: Theme.of(context).backgroundColor,
      backlayerColor: Theme.of(context).backgroundColor,
      leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      actions: <Widget>[IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      backLayer: LayoutBuilder(
        builder: (_, constraints) {
          final height = constraints.maxHeight - headerHeight;
          final width = (orientation == Orientation.portrait)
              ? constraints.maxWidth * 0.35
              : constraints.maxWidth * 0.3;
          return _buildBackLayer(height, width);
        },
      ),
      frontLayer: _buildFrontLayer(),
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

  Widget _buildFrontLayer() {
    return Container(
      child: Center(child: Text('My Classes'),),
    );
  }
}
