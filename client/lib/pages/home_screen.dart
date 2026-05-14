import 'package:client/pages/home/my_statics_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const String route = "home";

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        MyStaticsPage(),
       // MyRaidTimes()
      ],
    );
  }
}
