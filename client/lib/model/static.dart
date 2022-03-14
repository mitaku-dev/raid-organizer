import 'package:client/model/user.dart';

import 'member.dart';

class Static {
  String _name = "";
  int? _id;
  List<Member>? _members;
  User? _lead;
  String? _staticImageUrl;

  String get name => _name;
  int? get id => _id;
  List<Member>? get members => _members;
  User? get lead => lead;
  String? get staticImageUrl => _staticImageUrl;

  //TODO applications and schedules


  Static({
    id,
    required name,
    members,
    required lead,
    imageUrl
  }) {
    _id = id;
    _name = name;
    _members = members;
    _lead = lead;
    _staticImageUrl = imageUrl;
  }

  static Static fromMap(Map<String,dynamic> json){
    Static newStatic = Static(
        name: json['name'] ?? "",
        id: json['id'] ?? "",
        members: Member.listFromMap(json['members']),
        lead: User.fromMap(json['lead']),
        imageUrl: json['staticImageUrl'] ?? "",
    );
    return newStatic;
  }

  static List<Static> listFromMap(Iterable json){
    return List<Static>.from(json.map((model) => Static.fromMap(model)));
  }

}