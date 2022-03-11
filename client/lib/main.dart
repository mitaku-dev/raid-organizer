import 'package:client/constants.dart';
import 'package:client/controller/auth_provider.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:client/main_screen.dart';
import 'package:client/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        canvasColor: secondaryColor
      ),
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
      },
      builder: (context, child) => Overlay(
        initialEntries: [
          OverlayEntry(builder: (context) =>  MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuController(),
              ),
              ChangeNotifierProvider(
                create: (context) => AuthProvider(),
              )
            ],

              child: MainScreen(
                  child: child!
              )
          ))
        ],
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

}