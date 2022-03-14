
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {

  User? _user;
  User? get user => _user;


  //on init set User
  AuthProvider() {
    load();
  }

  load() async {
    _user = await HttpService().me();
  }


  setUser(User? user) {
    _user = user;
    notifyListeners();
  }



}