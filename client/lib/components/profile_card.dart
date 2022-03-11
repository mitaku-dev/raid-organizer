import 'package:client/controller/auth_provider.dart';
import 'package:client/model/user.dart';
import 'package:client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    User? user = context.read<AuthProvider>().user;

    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: user != null ?  NetworkImage(user.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
            radius: 16,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text( user!= null ? user.username : "Guest"),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
