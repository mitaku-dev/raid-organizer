import 'package:client/controller/auth_provider.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:client/model/user.dart';
import 'package:client/pages/login_screen.dart';
import 'package:client/pages/profile_screen.dart';
import 'package:client/service/http_service.dart';
import 'package:client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class ProfileCard extends StatefulWidget {
  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {

        return  Positioned(
          top: 10,
          right: 10,
          child: Container(
              margin: EdgeInsets.only(left: defaultPadding, right: 60),
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: defaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white10),
              ),
              child:  SizedBox(
                width: 150,
                child: Column(
                    children:[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: auth.user != null && auth.user?.profilePicUrl != "" ?  NetworkImage(auth.user!.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
                              radius: 16,
                            ),
                            if (!Responsive.isMobile(context))
                              Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                                child: Text( auth.user!= null ? auth.user!.username : "Guest"),
                              ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                      if(_expanded) ..._dropdownItems(context, auth.user)
                    ]
                  ),
              ),
          ),
        );
      },
    );
  }

  List<Widget> _dropdownItems(BuildContext context, User? user) {
    return [
      SizedBox(height: 10),
      const Divider(
        height: 3,
        thickness: 1,
        color: Colors.grey,
      ),
      const  ListTile(
          leading: Icon(Icons.app_settings_alt),
          title: Text("settings"),
        ),
      if(user != null)
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Profile"),
          onTap: () {
            context.read<MenuController>().pushNamed(ProfileScreen.route);
            setState(() {
              _expanded = false;
            });
          },
        ),
      ListTile(
          leading: Icon(Icons.login),
          title: Text(user != null ? "Logout" : "Login"),
          onTap: () {
            if(user != null) {
              HttpService().logout();
              context.read<AuthProvider>().setUser(null);
            }
            context.read<MenuController>().pushNamed(LoginScreen.route);
            setState(() {
              _expanded = false;
            });
          },
        ),
    ];
  }

}
