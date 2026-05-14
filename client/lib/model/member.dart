import 'package:client/model/user.dart';
import 'package:flutter/material.dart';

class Member {
  User? _user;
  String? _job;

  User? get user => _user;
  String? get job => _job;

  //TODO applications and schedules


  Member({
    required user,
    required job
  }) {
   _user = user;
   _job = job;
  }

  static Member fromMap(Map<String,dynamic> json){
    return Member(
      job: json['job'] ?? "",
      user: User.fromMap(json['user']),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "job": job,
      "userId": user?.id
    };
  }

  static List<Member> listFromMap(Iterable json){
    return List<Member>.from(json.map((model) => Member.fromMap(model)));
  }

  //TODO
  Color getJobColor() {
    switch(job) {
      case "pld":
      case "drk":
      case "gnb":
      case "war":
        return Colors.blue;
      case "whm":
      case "ast":
      case "sch":
        return Colors.green;
      default:
        return Colors.red;

    }
  }

}