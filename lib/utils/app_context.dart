import 'package:flutter/material.dart';

class ContextScreen {
  final String routeName;
  final BuildContext context;

  ContextScreen(this.routeName, this.context);
}

class AppContext {
  static final _contexts = Set<ContextScreen>();

  static BuildContext get last => (_contexts.isEmpty) ? null : _contexts.last.context;

  static String get name => (_contexts.isEmpty) ? null : _contexts.last.routeName;

  static void add(BuildContext context, [String routeName = 'some screen']) {
    _contexts.add(ContextScreen(routeName, context));
    print('added context $routeName ');
  }

  static void pop() {
    final ContextScreen last = _contexts.last;
    _contexts.remove(last);
    print('popped context ${last.routeName}');
  }
}
