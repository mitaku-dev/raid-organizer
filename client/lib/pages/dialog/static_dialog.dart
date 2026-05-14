import 'package:client/controller/auth_provider.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:client/controller/schedule_provider.dart';
import 'package:client/model/Schedule.dart';
import 'package:client/model/static.dart';
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../constants.dart';

class StaticDialog extends StatefulWidget {
  StaticDialog({Key? key}) : super(key: key);

  @override
  _StaticDialogState createState() => _StaticDialogState();
}

class _StaticDialogState extends State<StaticDialog> {

  final ImagePicker _imagePicker = ImagePicker();
  XFile? profileImagePicked;

  User? _leadSelected = null;
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleProvider(),
      child: Consumer<ScheduleProvider>(
        builder: (_,schedules,__) {
          return  Dialog(
            backgroundColor: bgColor,
            child: SizedBox(
              height: 600,
              width: 1000,
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: SizedBox(height: 560,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Static Name"),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: "Name"
                          ),
                        ),
                        SizedBox(height: defaultPadding,),
                        Text("Raid Leader"),
                        SizedBox(
                          height: 55,
                          child: DropdownSearch<User>(
                            selectedItem: _leadSelected,
                            onChanged: (User? user) {
                              _leadSelected = user;
                            },
                            //popupBackgroundColor: bgColor,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, user, isDisabled) {
                                return ListTile(
                                  leading:  CircleAvatar(
                                    backgroundImage:  user.profilePicUrl != "" ?  NetworkImage(user.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
                                    radius: 16,
                                  ),
                                  title: Text(user.username),
                                );
                              },
                              isFilterOnline: true
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Raid-Leader"
                              )
                            ),
                            asyncItems: (String? filter) async {
                              var response = await HttpService().api.get(
                                  "/user",
                                  queryParameters: {"filter": filter}
                              );
                              List<User> models = User.listFromMap(response.data);
                              return models;
                            },
                            dropdownBuilder: (context, selectedItem) {
                              if(selectedItem == null) return Container();
                              return ListTile(
                                leading:  CircleAvatar(
                                  backgroundImage: selectedItem != null && selectedItem.profilePicUrl != "" ?  NetworkImage(selectedItem.profilePicUrl) : AssetImage( "assets/images/profile_pic.png") as ImageProvider,
                                  radius: 16,
                                ),
                                title: Text(selectedItem.username), //TODO pic as prefix
                              );
                            },
                          ),
                        ),

                        Expanded(
                          child: Wrap(
                            //direction: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 400,
                                height: 400,
                                child: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: GestureDetector(
                                    onTap: _selectPicture,
                                    child: SizedBox(
                                      width: 350,
                                      height: 350,
                                      child: profileImagePicked != null ?
                                      Image.network(profileImagePicked!.path, fit: BoxFit.cover) :
                                      Container(color: Colors.black,
                                        child: Center(
                                            child: Icon(Icons.image_outlined, color: Colors.white54)
                                        )
                                        ,),
                                    ),
                                  ),
                                ),
                              ),
                              //VerticalDivider(),
                              SizedBox(
                                height: 600,
                                width: 500,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.access_time, color: Colors.orange,),
                                          SizedBox(width: 5,),
                                          Text("Raid times"),
                                          //Expanded(child: Container(),),
                                          IconButton(
                                            icon: Icon(Icons.add, color: Colors.orange,),
                                            onPressed: () {
                                              schedules.addSchedule(Schedule(
                                                day: "Sunday",
                                                start: TimeOfDay(hour: 0, minute: 0),
                                                  end: TimeOfDay(hour: 24, minute: 0)
                                              ));
                                            },
                                          ),
                                        ],
                                      ),
                                    // Divider(),
                                    //Builder
                                    SizedBox(
                                      height: 400,
                                      child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                            itemCount: schedules.schedules.length,
                                              itemBuilder: (context,index) {
                                                return SchedulePicker(
                                                    index: index,
                                                    onDelete: () {
                                                  schedules.removeSchedule(schedules.schedules[index]);
                                                });
                                              }
                                          ),
                                    ),

                                    //Divider(),

                                    //button to add raid times
                                    //list of timess
                                  ],
                                ),
                              )
                              //TODO verticalDivider or Divider depending on direction

                              //Image Selection
                              //Time Selection
                            ],
                          ),
                        ),
                        Expanded(child: Container(),),
                        Row(
                          children: [
                            ElevatedButton(onPressed: (){
                              context.read<CustomMenuController>().pop();
                              //context.read<CustomMenuController>();
                            }, child: Text("cancel")),
                            Expanded(child: Container(),),
                            ElevatedButton(onPressed: () => _save(schedules), child: Text("Save"))
                          ],
                        )

                        //TODO dropdown with users for things , me on top

                        //TODO
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }


  void _selectPicture() async {
    final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImagePicked = file;
    });
  }

   _save(ScheduleProvider schedule) {
      //TODO

       String name = _nameController.value.text;
       int id = _leadSelected!.id;

       //List<Schedule> schedules = List.empty();/*

    HttpService().createStatic(name,id, profileImagePicked, schedule.schedules);

     context.read<CustomMenuController>().pop();
  }

}

class SchedulePicker extends StatefulWidget {

  VoidCallback onDelete;
  int index;


  SchedulePicker({
    Key? key,
    required this.onDelete,
    required this.index
  }) : super(key: key);

  @override
  State<SchedulePicker> createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<SchedulePicker> {

  /*
  String? day = "Sunday";
  TimeOfDay startDate = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endDate = TimeOfDay(hour: 24, minute: 0);
*/


  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (_,schedule, __) {
        return Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              //Dropdown with Days Mo to So
              children: [
                DropdownButton<String>(
                  items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: schedule.get(widget.index).day,
                  icon: Icon(Icons.arrow_downward, color: highlightColor),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: highlightColor,
                  ),
                  onChanged: (String? newValue) {
                    schedule.updateDay(widget.index, newValue ?? "");
                  },
                ),

                SizedBox(width: 10,),
                SizedBox(
                  width: 120,
                  child: GestureDetector(
                      onTap: () {_selectStartDate(context, schedule);}, //_selectStartDate(context),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.orange
                            )
                        ),
                        child: Text(
                          schedule.get(widget.index).start.format(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(width: 5,),
                Text("-"),
                SizedBox(width: 5,),

                SizedBox(
                  width: 120,
                  child: GestureDetector(
                      onTap: () {_selectEndDate(context, schedule);},
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.orange
                            )
                        ),
                        child: Text(
                          schedule.get(widget.index).end.format(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(width: 5,),
                IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.delete, color: Colors.red)
                )
              ]
            //Field with TimePicker
          ),
        );
      }
    );
  }
  
  _selectEndDate(BuildContext context, ScheduleProvider schedule) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: schedule.get(widget.index).end,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    TimeOfDay startDate = schedule.get(widget.index).start;
    if(timeOfDay != null && (timeOfDay.hour + timeOfDay.minute/60.0) > (startDate.hour + startDate.minute/60.0))
    {
      schedule.updateEnd(widget.index, timeOfDay);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can't select an ending Time before starting Time"))
      );
      //snackbar
      //cant be before ...
    }
  }

  _selectStartDate(BuildContext context, ScheduleProvider schedule) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: schedule.get(widget.index).start,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    TimeOfDay endDate = schedule.get(widget.index).end;
    if(timeOfDay != null && (timeOfDay.hour + timeOfDay.minute/60.0) < (endDate.hour + endDate.minute/60.0))
    {
      schedule.updateStart(widget.index, timeOfDay);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can't select an starting Time after ending Time"))
      );
    }
  }

}
