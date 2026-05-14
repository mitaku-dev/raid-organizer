import 'package:client/model/job.dart';
import 'package:client/model/user.dart';
import 'package:client/pages/static_screen.dart';
import 'package:client/service/http_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoleSelection extends StatefulWidget {

  CustomSearchController<String> controller;
  String hintText;

  RoleSelection({Key? key, required CustomSearchController<String> this.controller, required this.hintText}) : super(key: key);

  @override
  _RoleSelectionState createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: widget.controller.value,
      items: Job.list(),
      onChanged: (String? value) {
        widget.controller.setValue(value);
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.hintText
        )
      ),
      popupProps: PopupProps.menu(
        itemBuilder: (context, job, isDisabled) {
          return ListTile(
            leading:  JobIcon(job: job, active: true,),
            title: Text(job),
          );
        },
        showSearchBox: true,
      ),
      //popupBackgroundColor: bgColor,
      dropdownBuilder: (context, selectedItem) {
        if(selectedItem == null) return Container();
        return ListTile(
          leading:  JobIcon(job: selectedItem, active: true,),
          title: Text(selectedItem),
        );
      },
    );
  }
}




class CustomSearchController<T> extends ChangeNotifier {
  T? value;

  void setValue(T? value) {
    this.value = value;
    notifyListeners();
  }

}