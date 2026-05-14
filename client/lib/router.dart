
import 'package:client/pages/home_screen.dart';
import 'package:client/pages/login_screen.dart';
import 'package:client/pages/page_not_found.dart';
import 'package:client/pages/profile_screen.dart';
import 'package:client/pages/register_page.dart';
import 'package:client/pages/static_overview.dart';
import 'package:client/pages/static_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute (RouteSettings settings) {
  switch(settings.name) {
    case '/':
    case HomeScreen.route:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case ProfileScreen.route:
      return MaterialPageRoute(builder: (context) => ProfileScreen());
    case RegisterPage.route:
      return MaterialPageRoute(builder: (context) => RegisterPage());
    case StaticScreen.route:
      return MaterialPageRoute(builder: (context) => StaticScreen());
    case StaticOverview.route:
      return MaterialPageRoute(builder: (context) => StaticOverview());
    default:
      return MaterialPageRoute(builder: (context) => PageNotFound(name: settings.name)); //TODO error page
  }
}