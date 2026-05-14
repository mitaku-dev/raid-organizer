import 'package:client/components/role_selection.dart';
import 'package:client/components/user_search.dart';
import 'package:client/constants.dart';
import 'package:client/model/member.dart';
import 'package:client/model/static.dart';
import 'package:client/model/user.dart';
import 'package:client/pages/arguments/static_arguments.dart';
import 'package:client/pages/static_screen.dart';
import 'package:client/service/http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class StaticOverview extends StatefulWidget {

  static const String route = "static";

  @override
  State<StaticOverview> createState() => _StaticOverviewState();
}

class _StaticOverviewState extends State<StaticOverview> {

  CustomSearchController<User?> _CustomSearchController = CustomSearchController<User?>();
  CustomSearchController<String> _jobController = CustomSearchController<String>();
  User? _newUser;

  @override
  void initState() {
    _CustomSearchController.addListener(() {
      setState(() {
        _newUser = _CustomSearchController.value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as StaticArguments;

    const isAdmin = true; //TODO



    return FutureBuilder(
        future: HttpService().getStatic(args.staticID),
        builder: (context, AsyncSnapshot<Static> snapshot) {
          if(snapshot.hasData) {
            Static static = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               Container(
                 height: 300,
                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     fit: BoxFit.cover,
                     image: NetworkImage(static.staticImageUrl!)
                   )
                 ),
               ),
                Text(static.name),
                Expanded(
                  child:   Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.people, color: Colors.orange,),
                              SizedBox(width: 5,),
                              Text("Members"),

                              IconButton(onPressed: () => {}, icon: Icon(Icons.add,color: Colors.orange,))
                            ],
                          ),
                          Divider(color: primaryColor),
                          SizedBox(height: 15,),
                          Expanded(child:
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange)
                              ),
                              child:StaticList(static.members!)
                            )
                          ),


                          Text(_newUser?.username ?? "new member todo"), //TODO
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          UserSearch(
                                            controller: _CustomSearchController,
                                            hintText: "Member",
                                          ),
                                          RoleSelection(
                                              controller: _jobController,
                                              hintText: "Job"
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                //TODO add to bla
                                                HttpService().addMember(static.id!,
                                                    Member(
                                                        user: _CustomSearchController.value,
                                                        job: _jobController.value
                                                    )).then((value) => setState((){}));
                                                _CustomSearchController.setValue(null);
                                                _jobController.setValue(null);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Add")
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Text(isAdmin ? "Add Member" :  "Apply to Static"),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.orange), //TODO off
                          Text("Visible to everyone"),
                          Checkbox(value: false, onChanged: (event) => {}),
                        ],
                      ),

                    ],
                  ),
                )



              ],
            );
          }else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}


class StaticList extends StatelessWidget {

  List<Member> memberList;

  StaticList(this.memberList);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ListView.separated(
          itemCount: memberList.length,
          itemBuilder: (context, index) {
            return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                tileColor: cardColor,
                leading: JobIcon(job: memberList[index].job!, active: true, size: 32),
                title: Text(
                    memberList[index].user!.username,
                    style: TextStyle(
                      color: memberList[index].getJobColor()
                    ),
                ),
              trailing:
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete, color: Colors.red)
                  )
            );
          },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
      ),
    );
  }
}
