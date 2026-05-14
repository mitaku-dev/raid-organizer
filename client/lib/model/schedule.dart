
import 'dart:convert';

import 'package:flutter/material.dart';


class Schedule {

  String day;
  TimeOfDay start;
  TimeOfDay end;

  Schedule({
    required this.day,
    required this.end,
    required this.start
  });



  Map<String,dynamic> toJson(){
    return {
      "day": day,
      "endHour": end.hour,
      "endMinute": end.minute,
      "startHour": start.hour,
      "startMinute": start.minute
    };
  }

  static List<Map<String,dynamic>> listToJson(List<Schedule> jsonList){
    return List<Map<String,dynamic>>.from(jsonList.map((model) => model.toJson()));
  }

  static Schedule fromMap(Map<String,dynamic> json){
    return Schedule(
        day: json['day'] ?? "",
        start: TimeOfDay(
          hour: json['startHour'],
          minute: json['startMinute']
        ),
        end: TimeOfDay(
          hour: json['endHour'],
          minute: json['endMinute'],
        )
    );
  }

  static List<Schedule> listFromMap(Iterable json){
    return List<Schedule>.from(json.map((model) => Schedule.fromMap(model)));
  }

}