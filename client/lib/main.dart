import 'package:client/constants.dart';
import 'package:client/controller/auth_provider.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:client/main_screen.dart';
import 'package:client/pages/home_screen.dart';
import 'package:client/pages/login_screen.dart';
import 'package:client/pages/profile_screen.dart';
import 'package:client/pages/register_page.dart';
import 'package:client/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(navigator: _navigator),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        initialRoute: LoginScreen.route,
        home: HomeScreen(),
        navigatorKey: _navigator,
        routes: {
          LoginScreen.route: (context) => LoginScreen(),
          HomeScreen.route: (context) => HomeScreen(),
          ProfileScreen.route: (context) => ProfileScreen(),
          RegisterPage.route: (context) => RegisterPage(),
        },
        builder: (context, child) => Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) =>  MainScreen(child: child!))
          ],
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }

}