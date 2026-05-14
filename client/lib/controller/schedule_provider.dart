
import 'dart:collection';

import 'package:client/model/Schedule.dart';
import 'package:client/model/static.dart';
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:flutter/material.dart';


class ScheduleProvider extends ChangeNotifier {

  late List<Schedule> _schedules;
  UnmodifiableListView<Schedule> get schedules => UnmodifiableListView(_schedules);

  ScheduleProvider() {
    _schedules = [];
  }

  addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  removeSchedule(Schedule schedule) {
    _schedules.remove(schedule);
    notifyListeners();
  }

  updateDay(int index, String day) {
    _schedules[index].day = day;
        notifyListeners();
  }
  updateStart(int index, TimeOfDay start) {
    _schedules[index].start = start;
    notifyListeners();
  }
  updateEnd(int index, TimeOfDay end) {
    _schedules[index].end = end;
    notifyListeners();
  }

  Schedule get(int index) {
    return _schedules[index];
  }



}

