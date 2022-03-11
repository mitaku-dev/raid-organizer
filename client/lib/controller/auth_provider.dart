import 'dart:convert';

import 'package:client/model/user.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {

  User? _user;
  String? _accesToken;
  String? _refreshToken;


  User? get user => _user;
  String? get accessToken => _accesToken;
  String? get refreshToken => _refreshToken;


  void logout() {
    _user = null;
    _accesToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void login(String username, String password) async{

    String uri = "localhost:8080/auth/login";

    http.Response response = await http.post(
        Uri.parse(uri),
        body: jsonEncode((<String,String>{
          'username': username,
          'password': password
        }))
    );

    if(response.statusCode == 200) {
      Map<String,dynamic> json = jsonDecode(response.body);
      _user = json['user'];
      //TODO user
      _accesToken = json['token'];
      _refreshToken = json['refreshToken'];
    }


    _user = User(username: "", profilePicUrl: "");
    notifyListeners();
  }


  void refresh() {
    _accesToken = "";
  }

}