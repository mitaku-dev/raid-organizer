import 'dart:convert';

import 'package:client/controller/auth_provider.dart';
import 'package:client/model/static.dart';
import 'package:client/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {

  HttpService._internal()  {
    api.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 403 ||
            error.response?.statusCode == 401) {
          await refresh();
          _retry(error.requestOptions);
        }
      },
      onRequest: (options, handler) async {
        //debugPrint(accessToken);
        if(accessToken != "") options.headers['Authorization'] = 'Bearer $accessToken';
        handler.next(options);
      },
    ));


  }

  init() async{
    storage =  await SharedPreferences.getInstance();
    accessToken = await storage!.getString("accessToken") ?? "";
    refreshToken = await storage!.getString("refreshToken") ?? "";

  }

  static final HttpService _singleton = HttpService._internal();
  static String accessToken = "";
  static String refreshToken = "";
  static SharedPreferences? storage;

  Dio api = Dio(
    BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: "http://192.168.178.75:8080"
    )
  );

  factory HttpService() {
    return _singleton;
  }


  Future<User?> login(String username, String password) async {

      Response response = await Dio().post(
          "http://192.168.178.75:8080/auth/login",
          data: jsonEncode((<String,String>{
            'username': username,
            'password': password
          }))
      );
      if(response.statusCode == 200) {

        Map<String,dynamic> json = response.data;

        User user = User.fromMap(json);

        accessToken = json['token'];
        refreshToken = json['refreshToken'];

        storage!.setString("accessToken", accessToken);
        storage!.setString("refreshToken", refreshToken);


        return Future.value(user);
      }


      return Future.value(null);


  }


  Future<User?> me() async {

    Response response = await api.get("/user/me");

    if(response.statusCode == 200) {
      Map<String,dynamic> json = response.data;
      User user = User.fromMap(json);
      return Future.value(user);
    }else {
      return Future.value(null);
    }
  }

  void logout() async {
    accessToken = "";
    refreshToken = "";
    final storage =  await SharedPreferences.getInstance();
    storage.remove("accessToken");
    storage.remove("refreshToken");
  }



  Future<int?> changePassword(String oldPw, String newPw) async {
    Response response = await api.post(
        "/user/me/password",
        data: jsonEncode(<String,String>{
          'oldPassword': oldPw,
          'newPassword': newPw
        })
    );
    return response.statusCode;
  }

  Future<void> delete() async {
    Response response = await api.delete("/user/me");
    if(response.statusCode == 200) {
      logout();
    }
  }


  Future<User?> register(String username, String email, String password, String password2) async {

    Response response = await api.post(
        "/auth/register",
        data: jsonEncode((<String,String>{
          'username': username,
          'password': password,
          'passwordRepeat': password2,
          'email': email
        }))
    );

    if(response.statusCode == 200) {
      Map<String,dynamic> json = response.data;

      User user = User.fromMap(json);

      accessToken = json['token'];
      refreshToken = json['refreshToken'];

      storage!.setString("accessToken", accessToken);
      storage!.setString("refreshToken", refreshToken);

      return Future.value(user);
    } else  {
      return Future.value(null);
    }

  }



  void updateImage(XFile file) async {

    MultipartFile netFile = await MultipartFile.fromBytes(
        await file.readAsBytes(),
        filename: file.name,
        //contentType: MediaType.parse(file.mimeType!)
    );

    FormData formData = FormData.fromMap({
      "image":
          await netFile
    });

    Response response = await api.post(
        "/images/user",
      data: formData
    );

    if(response.statusCode == 200) {
      return Future.value(true);
    } else  {
      return Future.value(false);
    }

  }


  Future<List<Static>> getStatics() async {
    Response response = await api.get("/static");
    if(response.statusCode == 200) {
      Iterable json = response.data;
      List<Static> statics = Static.listFromMap(json);
      return Future.value(statics);
    }else {
      return Future.value(null);
    }
  }





  Future<void> refresh() async {
    final refreshToken = await storage!.getString('refreshToken');
    final response =
    await api.post('/users/refresh', data: {'token': refreshToken});

    if (response.statusCode == 200) {
      accessToken = response.data['accessToken'];
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }



}