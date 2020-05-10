import 'package:flutter/material.dart';

class HomeFrontLayer extends StatefulWidget {
  final Widget frontLayer;
  final Function reverse;

  const HomeFrontLayer({Key key, this.frontLayer, this.reverse}) : super(key: key);

  @override
  HomeFrontLayerState createState() => HomeFrontLayerState();
}

class HomeFrontLayerState extends State<HomeFrontLayer> {
  bool isOffstage = false;

  void toOffstage() {
    setState(() => isOffstage = true);
  }

  void toStage() {
    setState(() => isOffstage = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isOffstage) ? widget.reverse : null,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: widget.frontLayer,
          ),
          IgnorePointer(
            ignoring: !isOffstage,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: isOffstage ? 1 : 0,
              child: Container(color: Colors.black12),
            ),
          )
        ],
      ),
    );
  }
}
