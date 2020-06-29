import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justclass/widgets/app_icon_button.dart';
import 'package:justclass/widgets/home_screen_front_layer.dart';

class HomeBackdropScaffold extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  final Color backColor;
  final double dropDistance;
  final Widget backLayer;
  final Widget frontLayer;

  HomeBackdropScaffold({
    Key key,
    this.leading,
    this.title,
    this.actions,
    this.backColor,
    this.dropDistance,
    this.backLayer,
    this.frontLayer,
  }) : super(key: key);

  @override
  HomeBackdropScaffoldState createState() => HomeBackdropScaffoldState();
}

class HomeBackdropScaffoldState extends State<HomeBackdropScaffold> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotateAnim;
  Animation<Offset> _translateAnim;

  final _frontLayerKey = GlobalKey<HomeFrontLayerState>();

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void forward() {
    _controller.forward();
    _frontLayerKey.currentState.toOffstage();
  }

  void reserve() {
    _controller.reverse();
    _frontLayerKey.currentState.toStage();
  }

  void swap() {
    _controller.isDismissed ? forward() : reserve();
  }

  Future<bool> _onWillPopScope() async {
    if (_frontLayerKey.currentState.isOffstage) {
      swap();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _rotateAnim = Tween<double>(begin: 0, end: -0.75 * pi).animate(_controller);
    _translateAnim = Tween<Offset>(begin: Offset.zero, end: Offset(0, widget.dropDistance)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        backgroundColor: widget.backColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: widget.leading,
          title: widget.title,
          actions: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.rotate(angle: _rotateAnim.value, child: child),
              child: AppIconButton(icon: const Icon(Icons.add, size: 30), onPressed: swap, tooltip: 'New Class'),
            ),
            ...widget.actions
          ],
          backgroundColor: widget.backColor,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: widget.dropDistance,
                width: double.infinity,
                child: widget.backLayer,
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) => Transform.translate(offset: _translateAnim.value, child: child),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: HomeFrontLayer(key: _frontLayerKey, frontLayer: widget.frontLayer, reverse: swap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
