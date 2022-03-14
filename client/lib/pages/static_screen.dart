import 'package:client/controller/auth_provider.dart';
import 'package:client/model/member.dart';
import 'package:client/model/static.dart';
import 'package:client/pages/dialog/static_dialog.dart';
import 'package:client/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class StaticScreen extends StatefulWidget {

  static const String route = "statics";

  @override
  State<StaticScreen> createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //TODO SearchBar
        Row(
          children: [
            //Search // add
            const SizedBox(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search)
                  ),
                )
            ),
            const SizedBox(width: 30,),
            SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right:20),
                child: ElevatedButton(
                    onPressed: _addStatic,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add),
                          Text("add")
                        ],
                    )
                ),
              ),
            )
            //add
          ],
        ),
        SizedBox(height: 40,),
        FutureBuilder(
          future: HttpService().getStatics(),
            builder: (context, AsyncSnapshot<List<Static>> snapshot) {
              List<Static> statics = snapshot.data ?? List.empty();
              return Wrap(
                direction: Axis.vertical,
                children: statics.map((el) => StaticCard(static: el)).toList()
              );


            }
        )
       // ListView.builder(itemBuilder: itemBuilder)
      ],
    );
  }

  _addStatic() {

  showDialog(
      context: context,
      builder: (context) {
        return StaticDialog();
      }
  );
    //TODO fullscreenDialog or ... on Desktop SimpleDialog

  }

}


class StaticCard extends StatelessWidget {

  final Static static;

  StaticCard({required this.static});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      //height: 600,
      child: Card(
          color: Colors.black38,
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Column(
                      children: [
                        SizedBox(
                          height: 300,
                          width: 400,
                          child:   static.staticImageUrl != "" ?
                          Image.network(static.staticImageUrl!):
                          Container(color: Colors.black),
                        ),
                        SizedBox(height: 5,),
                        Text(static.name, style: Theme.of(context).textTheme.headline3,),
                        SizedBox(height: 10,)
                      ],
                    ),
                  SizedBox(width: 20,),
                  Expanded(child: Container(),),
                  SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 25,),
                          Row(
                            children: const [
                              Icon(Icons.access_time, color: Colors.orange,),
                              SizedBox(width: 5,),
                              Text("Raid times"),
                           ],
                          ),
                        SizedBox(height: 15,),
                        //TODO
                        Row(
                          children: const [
                            Text("Sunday:"),
                            SizedBox(width: 10,),
                            Text("20:00"),
                            SizedBox(width: 5,),
                            Text("-"),
                            SizedBox(width: 5,),
                            Text("22:00")
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        Row(
                          children: const [
                            Icon(Icons.people, color: Colors.orange,),
                            SizedBox(width: 5,),
                            Text("Members"),
                          ],
                        ),
                        SizedBox(height: 15,),
                        ClassList(members: static.members!),
                        SizedBox(height: 5),
                        Divider(),
                        Row(
                          children: const [
                            Icon(Icons.directions_run, color: Colors.orange,),
                            SizedBox(width: 5,),
                            Text("Progress"),
                          ],
                        ),
                        SizedBox(height: 15,),


                          //TODO progess

                          //footer with classes as icnons
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),

      ),
    );
  }
}

class ClassList extends StatelessWidget {

  List<Member> members;

  ClassList({
    required this.members
  });

  @override
  Widget build(BuildContext context) {

    List<Widget> jobIcons = [];
    for(Member m in members) {
        jobIcons.add(JobIcon(job: m.job!, active: true,));
        //m.job == "WAR", "PLD", "DRK" // etc."
    }

    return  Wrap(
        alignment: WrapAlignment.start,
        children: jobIcons
        /*
        [
          JobIcon(job: "tank", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "tank", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "heal", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "heal", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "dps", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "dps", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "dps", active: false),
          const SizedBox(width: defaultPadding,),
          JobIcon(job: "dps", active: false),
        ] */
    );
  }
}

class JobIcon extends StatelessWidget {

  String job;
  bool active;

  JobIcon({
    required this.job,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     height: 22,
     width: 22,
      child:  Opacity(
          opacity: active ? 1 : 0.5,
          child: Image.asset(_getIcon()),
      ),
    );
  }

  String _getIcon() {
    if(job == "dps") {
      return "assets/images/role/DPSRole.png";
    } else if(job == "heal") {
      return "assets/images/role/HealerRole.png";
    } else if(job == "tank") {
      return "assets/images/role/TankRole.png";
    } else {
      return "assets/images/jobs/"+job+".png";
    }
  }
}
