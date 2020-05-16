import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justclass/utils/constants.dart';

class TeacherFloatingActionButton extends StatefulWidget {
  final double bottomDistance;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Map<String, dynamic>> actions; // tooltip, child and onPressed

  const TeacherFloatingActionButton({
    this.bottomDistance = 0,
    @required this.actions,
    @required this.primaryColor,
    @required this.secondaryColor,
  });

  @override
  _TeacherFloatingActionButtonState createState() => _TeacherFloatingActionButtonState();
}

class _TeacherFloatingActionButtonState extends State<TeacherFloatingActionButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animTranslate;
  Animation<double> _animAngle;
  Animation<double> _animOpacity;

  final _btnHeight = btnHeight;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animTranslate = Tween<Offset>(begin: Offset.zero, end: const Offset(-65, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack));
    _animAngle = Tween<double>(begin: 0, end: -0.75 * pi).animate(_controller);
    _animOpacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.3, 1, curve: Curves.easeOutQuad)));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(width: 300, height: widget.bottomDistance + _btnHeight),
        ...widget.actions.map(
          (action) {
            final index = widget.actions.indexOf(action);
            return Positioned(
              top: 0,
              bottom: 0,
              right: 5,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Transform.translate(
                  offset: _animTranslate.value * (widget.actions.length - index).toDouble(),
                  child: Opacity(opacity: _animOpacity.value, child: child),
                ),
                child: SizedBox(
                  width: 50,
                  child: Tooltip(
                    message: action['tooltip'],
                    verticalOffset: -60,
                    child: FloatingActionButton(
                      elevation: 2,
                      heroTag: action['tooltip'],
                      backgroundColor: widget.secondaryColor,
                      onPressed: action['onPressed'],
                      child: action['child'],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: SizedBox(
            width: _btnHeight,
            child: FloatingActionButton(
              elevation: 2,
              heroTag: 'add component button',
              backgroundColor: widget.primaryColor,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Transform.rotate(angle: _animAngle.value, child: child),
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
              onPressed: () {
                (_controller.value == 1) ? _controller.reverse() : _controller.forward();
              },
            ),
          ),
        ),
      ],
    );
  }
}
