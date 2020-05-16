import 'package:flutter/material.dart';

class ContextScreen {
  final String routeName;
  final BuildContext context;

  ContextScreen(this.routeName, this.context);
}

class AppContext {
  static final _contexts = Set<ContextScreen>();

  static get last => _contexts.last?.context;

  static void add(BuildContext context, [String routeName = 'screen']) {
    print('add $routeName');
    _contexts.add(ContextScreen(routeName, context));
  }

  static void pop() {
    final last = _contexts.last;
    print('pop ${last.routeName}');
    _contexts.remove(last);
  }
}
