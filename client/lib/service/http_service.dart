import 'dart:convert';

import 'package:client/controller/auth_provider.dart';
import 'package:client/model/Schedule.dart';
import 'package:client/model/member.dart';
import 'package:client/model/static.dart';
import 'package:client/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {

  static const MAX_RETRIES = 4;
  static const BASE_URL = "http://localhost:8080";

  HttpService._internal()  {
    api.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 403 ||
            error.response?.statusCode == 401) {
          await refresh();
          _retry(error.requestOptions); //TODO limit to tries
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
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        baseUrl: BASE_URL
    )
  );

  factory HttpService() {
    return _singleton;
  }


  Future<User?> login(String username, String password) async {

      Response response = await Dio().post(
          "${BASE_URL}/auth/login",
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


  Future<bool> createStatic(String name, int id, XFile? image, List<Schedule> schedules) async {


    if(name != "" && id != 0) {
      Response response = await api.post(
          "/static",
          data: jsonEncode((<String,dynamic>{
            "name" : name,
            "leadId": id,
            "schedules": Schedule.listToJson(schedules),
          }))
      );

      if(response.statusCode == 200) {

        int staticId = response.data['id'];
        if(image != null) {
          bool success = await updateStaticImage(staticId, image);
          return Future.value(success);
        }

      }
    }

    return Future.value(false);
    //todo refresh overview
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


  Future<bool> updateStaticImage(int id, XFile file) async {

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
        "/images/static/"+id.toString(),
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

  Future<List<Static>> getMyStatics() async {
    Response response = await api.get("/user/me/statics");
    if(response.statusCode == 200) {
      Iterable json = response.data;
      List<Static> statics = Static.listFromMap(json);
      return Future.value(statics);
    }else {
      return Future.value(null);
    }
  }



  Future<Static> getStatic(int staticId) async {
    Response response = await api.get("/static/"+staticId.toString());
    if(response.statusCode == 200) {
      Map<String,dynamic> json = response.data;
      Static static = Static.fromMap(json);
      return Future.value(static);
    }else {
      return Future.value(null);
    }
  }




  Future<void> addMember(int id, Member member) async {

    Response response = await api.post(
        "/static/"+id.toString()+"/member",
        data: jsonEncode(member.toJson())
    );

    if(response.statusCode == 200) {
      //Map<String,dynamic> json = response.data;


      return Future.value();
    } else  {
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