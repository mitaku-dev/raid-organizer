import 'package:flutter/material.dart';

class CustomMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  final GlobalKey<NavigatorState> navigator;

  CustomMenuController({required GlobalKey<NavigatorState> this.navigator});


  void pushNamed(String route) {
    navigator.currentState!.pushNamed(route);
  }

  void pop() {
    navigator.currentState!.pop();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}