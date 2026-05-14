import 'package:client/model/schedule.dart';
import 'package:client/model/user.dart';

import 'job.dart';
import 'member.dart';

class Static {
  String _name = "";
  int? _id;
  List<Member>? _members;
  User? _lead;
  String? _staticImageUrl;
  List<Schedule>? _schedules;

  String get name => _name;
  int? get id => _id;
  List<Member>? get members => _members;
  User? get lead => lead;
  String? get staticImageUrl => _staticImageUrl;
  List<Schedule>? get schedules => _schedules;

  //TODO applications and schedules



  Static({
    id,
    required name,
    members,
    required lead,
    imageUrl,
    schedules
  }) {
    _id = id;
    _name = name;
    _members = members;
    _lead = lead;
    _staticImageUrl = imageUrl;
    _schedules = schedules;
    _members!.sort((a,b) => compareJob(a.job!,b.job!));
  }


  int compareJob(String job1, String job2) {
    if(Job.isTank(job1)) return -1;
    if(Job.isTank(job2)) return 1;

    if(Job.isHeal(job1)) return -1;
    if(Job.isHeal(job2)) return 1;

    return  0;
  }

  static Static fromMap(Map<String,dynamic> json){
    Static newStatic = Static(
        name: json['name'] ?? "",
        id: json['id'] ?? "",
        members: Member.listFromMap(json['members']),
        lead: User.fromMap(json['lead']),
        imageUrl: json['staticImageUrl'] ?? "",
        schedules: Schedule.listFromMap(json['schedules'])
    );
    return newStatic;
  }

  static List<Static> listFromMap(Iterable json){
    return List<Static>.from(json.map((model) => Static.fromMap(model)));
  }

}