import 'package:client/components/role_selection.dart';
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UserSearch extends StatefulWidget {

  CustomSearchController<User?> controller;
  String hintText;

  UserSearch({Key? key, required CustomSearchController<User?> this.controller, required this.hintText}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<User>(
      selectedItem: widget.controller.value,
      onChanged: (User? user) {
        widget.controller.setValue(user);
      },
      //popupBackgroundColor: bgColor,
      //disableFilter: true,
      asyncItems:(String? filter) async {
        var response = await HttpService().api.get(
            "/user",
            queryParameters: {"filter": filter}
        );
        List<User> models = User.listFromMap(response.data);
        return models;
      },
      dropdownBuilder: (context, selectedItem) {
        if(selectedItem == null) return Container();
        return ListTile(
          leading:  CircleAvatar(
            backgroundImage: selectedItem != null && selectedItem.profilePicUrl != "" ?  NetworkImage(selectedItem.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
            radius: 16,
          ),
          title: Text(selectedItem.username),
        );
      },
      popupProps: PopupProps.menu(
          showSearchBox: true,
        itemBuilder:  (context, user, isDisabled) {
          return ListTile(
            leading:  CircleAvatar(
              backgroundImage:  user.profilePicUrl != "" ?  NetworkImage(user.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
              radius: 16,
            ),
            title: Text(user.username),
          );
        }
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            hintText: widget.hintText
        ),
      ),
    );
  }
}
