import 'package:client/components/side_menu.dart';
import 'package:client/constants.dart';
import 'package:client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'components/header.dart';
import 'controller/menu_controller.dart';

class MainScreen extends StatelessWidget {

  final Widget child;

  const MainScreen({
    Key? key,
    required this.child,
}): super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(Responsive.isDesktop(context))
              Expanded(
                child: SideMenu()
              ),
            Expanded(
              flex: 5,
              child: Column(
                    children: [
                        Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Header()
                        ),
                      Expanded(
                        child:  Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: child)
                        ,
                      )
                    ],
                )
              )
          ],
        )
      )
    );
  }


}
