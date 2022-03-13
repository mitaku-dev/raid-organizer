import 'package:client/components/profile_card.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        if(!Responsive.isMobile(context))
          Text(
            "RaidOrganizer",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        //Expanded(child: SearchField()),
        // ProfileCard(),

      ],
    );
  }
}
