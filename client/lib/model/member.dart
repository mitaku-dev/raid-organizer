import 'package:client/model/user.dart';

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

  static List<Member> listFromMap(Iterable json){
    return List<Member>.from(json.map((model) => Member.fromMap(model)));
  }

}