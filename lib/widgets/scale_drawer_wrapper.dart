import 'package:flutter/material.dart';

class ScaleDrawerWrapper extends StatefulWidget {
  final Widget drawerContent;
  final Widget topScaffold;

  const ScaleDrawerWrapper({
    Key key,
    @required this.topScaffold,
    @required this.drawerContent,
  }) : super(key: key);

  @override
  ScaleDrawerWrapperState createState() => ScaleDrawerWrapperState();
}

class ScaleDrawerWrapperState extends State<ScaleDrawerWrapper> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _translateAnim;
  Animation<double> _scaleAnim;

  static const _drawerWidth = 275.0;

  bool _canBeDragged = true;

//  bool _isOffScreen = false;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _translateAnim = Tween<double>(begin: 0, end: _drawerWidth).animate(_controller);
    _scaleAnim = Tween<double>(begin: 1, end: 0.7).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.6),
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void open() {
//    setState(() => _isOffScreen = true);
    _controller.forward();
  }

  void close() {
    _controller.reverse();
//    _controller.reverse().then((_) {
//      setState(() => _isOffScreen = false);
//    });
  }

  void swap() {
    (_controller.isCompleted) ? close() : open();
  }

  Future<bool> _onWillPop() {
    if (!_controller.isDismissed) {
      close();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _controller.isDismissed && details.globalPosition.dx < 50;
    bool isDragOpenFromRight = _controller.isCompleted && details.globalPosition.dx > _drawerWidth;
    _canBeDragged = isDragOpenFromLeft || isDragOpenFromRight;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / 300;
      _controller.value += delta;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.isCompleted || _controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      final width = MediaQuery.of(context).size.width;
      double visualVelocity = details.velocity.pixelsPerSecond.dx / width;
      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Stack(
          children: <Widget>[
            Positioned(
              width: _drawerWidth,
              child: widget.drawerContent,
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(_translateAnim.value)
                    ..scale(_scaleAnim.value),
                  alignment: Alignment.centerLeft,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: close,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15, offset: Offset(3, 3))],
//                    borderRadius: !_isOffScreen ? BorderRadius.zero : BorderRadius.circular(15),
                  ),
//                  child: ClipRRect(
//                    borderRadius: !_isOffScreen ? BorderRadius.zero : BorderRadius.circular(15),
//                  child: IgnorePointer(ignoring: !_controller.isDismissed, child: widget.scaffold),
//                  ),
                  child: ClipRRect(child: widget.topScaffold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
