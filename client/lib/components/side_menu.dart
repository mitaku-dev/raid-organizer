import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png")
          ),
          DrawerListTile(
            title: "Home",
            icon: Icons.home,
            action: () {},
          ),
          DrawerListTile(
            title: "Statics",
            icon: Icons.people,
            action: () {},
          ),
          DrawerListTile(
            title: "Forum",
            icon: Icons.question_answer,
            action: () {},
          ),
          DrawerListTile(
            title: "About",
            icon: Icons.help,
            action: () {},
          )
        ],
      )
    );
  }
}

class DrawerListTile extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback action;

  const DrawerListTile({
      Key? key,
      required this.title,
      required this.icon,
      required this.action,
    }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Colors.white54,
        size: 16.0
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54)
      )
    );
  }





}
