import 'package:client/controller/auth_provider.dart';
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class StaticDialog extends StatefulWidget {
  StaticDialog({Key? key}) : super(key: key);

  @override
  _StaticDialogState createState() => _StaticDialogState();
}

class _StaticDialogState extends State<StaticDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 600,
        width: 1000,
        child: Column(
          children: [
            TextField(),
            DropdownSearch<User>(
                mode: Mode.MENU,
                isFilteredOnline: true,
                onFind: (String? filter) async {
                  var response = await HttpService().api.get(
                    "/user",
                    queryParameters: {"filter": filter}
                  );
                  List<User> models = User.listFromMap(response.data);
                  return models;
                },
              showSearchBox: true,
              dropdownBuilder: (context, selectedItem) {
                  if(selectedItem == null) return Container();
                 return ListTile(
                   leading:  CircleAvatar(
                     backgroundImage: selectedItem != null && selectedItem.profilePicUrl != "" ?  NetworkImage(selectedItem.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
                     radius: 16,
                   ),
                   title: Text(selectedItem.username), //TODO pic as prefic
                 );
              },
              popupItemBuilder: (context, user, someBool) {
                  return ListTile(
                    leading:  CircleAvatar(
                      backgroundImage:  user.profilePicUrl != "" ?  NetworkImage(user.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
                      radius: 16,
                    ),
                    title: Text(user.username),
                  );
              },
              dropdownSearchDecoration: InputDecoration(
                hintText: "Raid-Leader"
              ),
            ),

            //TODO dropdown with users for things , me on top

            //TODO
          ],
        ),
      ),
    );
  }
}