import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:client/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class AuthProvider extends ChangeNotifier {

  User? _user;
  String? _accesToken;
  String? _refreshToken;


  User? get user => _user;
  String? get accessToken => _accesToken;
  String? get refreshToken => _refreshToken;


  static final String BASE_URL = "http://192.168.178.75:8080";

  AuthProvider() {
    load();
  }


  Future<void> load() async {
    final storage =  await SharedPreferences.getInstance();
    _accesToken = await storage.getString("accessToken");
    _refreshToken = await storage.getString("refreshToken");
    me();
  }


  void logout() async {
    _user = null;
    _accesToken = null;
    _refreshToken = null;

    final storage =  await SharedPreferences.getInstance();
    storage.remove("accessToken");
    storage.remove("refreshToken");

    notifyListeners();
  }


  Future<User?> me() async {
    String uri = BASE_URL + "/user/me";

    http.Response response = await http.get(
        Uri.parse(uri),

        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_accesToken',
        },
    );

    if(response.statusCode == 200) {
      Map<String,dynamic> json = jsonDecode(response.body);
      //TODO better
      _user = User.fromMap(json);
      notifyListeners();
      return Future.value(user);
    }else {
      return Future.value(null);
    }
  }


  Future<int> changePassword(String oldPw, String newPw) async {
    String uri = BASE_URL + "/user/me/password";

    http.Response response = await http.post(
      Uri.parse(uri),

      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
      body: jsonEncode(<String,String>{
        'oldPassword': oldPw,
        'newPassword': newPw
      })
    );
    return response.statusCode;
  }
  Future<void> delete() async {
    String uri = BASE_URL + "/user/me";

    http.Response response = await http.delete(
      Uri.parse(uri),

      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_accesToken',
      },
    );

    if(response.statusCode == 200) {
      logout();
    }
  }


  Future<bool> login(String username, String password) async {

    String uri = BASE_URL + "/auth/login";

    http.Response response = await http.post(
        Uri.parse(uri),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json"
        },
        body: jsonEncode((<String,String>{
          'username': username,
          'password': password
        }))
    );

    if(response.statusCode == 200) {
      Map<String,dynamic> json = jsonDecode(response.body);
      //TODO user
      _user = User.fromMap(json);


      _accesToken = json['token'];
      _refreshToken = json['refreshToken'];

      //TODO storage.write
      final storage =  await SharedPreferences.getInstance();
      storage.setString("accessToken", _accesToken!);
      storage.setString("refreshToken", _refreshToken!);

      notifyListeners();
      return Future.value(true);
    } else  {
      return Future.value(false);
    }

  }

  Future<bool> register(String username, String email, String password, String password2) async {

    String uri = BASE_URL + "/auth/register";

    http.Response response = await http.post(
        Uri.parse(uri),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json"
        },
        body: jsonEncode((<String,String>{
          'username': username,
          'password': password,
          'passwordRepeat': password2,
          'email': email
        }))
    );

    if(response.statusCode == 200) {
      Map<String,dynamic> json = jsonDecode(response.body);

      _user = User.fromMap(json);

      _accesToken = json['token'];
      _refreshToken = json['refreshToken'];


      final storage =  await SharedPreferences.getInstance();
      storage.setString("accessToken", _accesToken!);
      storage.setString("refreshToken", _refreshToken!);

      notifyListeners();
      return Future.value(true);
    } else  {
      return Future.value(false);
    }

  }



  void updateImage(XFile file) async {

    String uri = BASE_URL + "/images";

    http.MultipartFile netFile = await http.MultipartFile.fromBytes(
      "image",
        await file.readAsBytes(),
        filename: file.name,
         contentType: MediaType.parse(file.mimeType!)
    );

    var request = http.MultipartRequest("POST", Uri.parse(uri));
    request.headers.addAll({
      'Authorization': 'Bearer $_accesToken',
    });
    request.files.add(netFile);

    var response = await request.send();


    if(response.statusCode == 200) {

      //TODO -> does it refresh even if nothing changes??
      notifyListeners();
      return Future.value(true);
    } else  {
      return Future.value(false);
    }

  }



  void refresh() {
    _accesToken = "";
  }

}