import 'dart:io';

import 'package:client/components/password_input.dart';
import 'package:client/controller/auth_provider.dart';
import 'package:client/model/user.dart';
import 'package:client/service/http_service.dart';
import 'package:client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {


  static const String route = "me";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? profileImagePicked;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: HttpService().me(),
      builder: (context, AsyncSnapshot<User?> snapshot) {

        _usernameController.text = snapshot.data?.username ?? "";
        _emailController.text = snapshot.data?.email ??  "";

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileSection(
                  title: "Profile Information",
                  description: "Update your account's information",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Profile Picture"),
                      GestureDetector(
                        onTap: _changePicture,
                        child: Center(
                          child: CircleAvatar(
                            //TODO network image if user is set
                            backgroundImage: profileImagePicked != null ? NetworkImage(profileImagePicked!.path) :
                            (snapshot.data?.profilePicUrl != null ?
                            NetworkImage(snapshot.data!.profilePicUrl) :
                            AssetImage("assets/images/profile_pic.png")
                            ) as ImageProvider,
                            radius: 128,
                            /*
                            backgroundImage: profileImagePicked != null ? NetworkImage(profileImagePicked!.path) :
                             , */

                          ),
                        ),
                      ),
                      const Divider(),
                      const Text("Username", textAlign: TextAlign.start,),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 600,
                        child: TextField(
                          controller: _usernameController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Email", textAlign: TextAlign.start,),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 600,
                        child: TextField(
                          enabled: false,
                          style: const TextStyle(
                            color: Colors.white30
                          ),
                          controller: _emailController,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                  footer: ElevatedButton(onPressed: () async {
                    //TODO save image and username
                    if(profileImagePicked != null) {
                      HttpService().updateImage(profileImagePicked!);

                    }

                    var snackBar = SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.info, color: Colors.orange,),
                            SizedBox(width: 10,),
                            Text("Profile Information Saved")
                          ],
                        )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //TODO saved message

                  }, child: Text("Save"))
              ),
              SizedBox(height: 50,),

              //TODO password change

              ProfileSection(
                  title: "Password",
                  description: "Change your password",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Old Password", textAlign: TextAlign.start,),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 600,
                        child: PasswordInput(
                          controller: _passwordController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("New Password", textAlign: TextAlign.start,),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 600,
                        child: PasswordInput(
                          controller: _newPasswordController,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                  footer: ElevatedButton(onPressed: () async {

                    int? status = await HttpService()
                        .changePassword(
                        _passwordController.value.text,
                        _newPasswordController.value.text
                    );

                    var snackBar;

                    if(status == 200) {
                      snackBar =  SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.info, color: Colors.orange,),
                              SizedBox(width: 10,),
                              Text("Password successful changed")
                            ],
                          )
                      );
                    } else { //401
                      snackBar =  SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.info, color: Colors.orange,),
                              SizedBox(width: 10,),
                              Text("Old Password was wrong")
                            ],
                          )
                      );
                    }

                    _passwordController.text = "";
                    _newPasswordController.text = "";

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  }, child: Text("Save"))
              ),
              SizedBox(height: 50,),
              ProfileSection(
                  title: "Account Settings",
                  description: "Manage your account",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hide Account"),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "If you hide your account nobody can search you or see any information about you! \n"
                                  "But you wont be able to use most of tge features",
                              style: TextStyle(
                                  color: Colors.white54
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {},
                                style:  ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  shape : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  const [
                                      Icon(Icons.visibility_off),
                                      Text("Hide")
                                    ] )
                            ),
                          ),
                          SizedBox(width: 50,)
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text("Delete Account"),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                                "If you delete your account the account cant be restored!",
                              style: TextStyle(
                                color: Colors.white54
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {

                                  TextEditingController _deleteController = TextEditingController();

                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 400,
                                          color: Colors.black54,
                                          child:
                                            Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                      "Do you really want to delete your account?",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 24
                                                    ),
                                                  ),
                                                  SizedBox(height:20),
                                                  Text("If you do your account cant be estored. To complete deletion please enter the Text DELETE below:"),
                                                  SizedBox(height:100),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          width: Responsive.isMobile(context) ? 200 : 400,
                                                          height: 50,
                                                          child: TextField(
                                                            controller: _deleteController,
                                                            style:  const TextStyle(
                                                              color: Colors.red
                                                            ),
                                                          )),
                                                      const SizedBox(width: 20,),
                                                      SizedBox(
                                                        height: 50,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.red,
                                                              shape : RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                            ),
                                                            onPressed: () {

                                                              if(_deleteController.value.text == "DELETE") {
                                                                HttpService().delete();
                                                                var snackBar = SnackBar(
                                                                    content: Row(
                                                                      children: const [
                                                                        Icon(Icons.info, color: Colors.orange,),
                                                                        SizedBox(width: 10,),
                                                                        Text("Your account just got yeeeeeeeted lol") //TODO
                                                                      ],
                                                                    )
                                                                );
                                                                Navigator.of(context).pushNamed("login");
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              } else {
                                                                _deleteController.text = "";
                                                              }


                                                        }, child: Text("Delete")),
                                                      )
                                                    ],
                                                  ),


                                                ],
                                              )
                                            )
                                        );
                                      }
                                  );




                                },
                                style:  ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  const [
                                      Icon(Icons.delete),
                                      Text("Delete")
                                    ] )
                            ),
                          ),
                          SizedBox(width: 50,)
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              )


            ],
          ),
        );
      },
    );
  }

  void _changePicture() async {
    final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImagePicked = file;
    });
  }
}


class ProfileSection extends StatelessWidget {

  final String title;
  final String description;
  final Widget child;
  final Widget? footer;

  const ProfileSection({
    required this.title,
    required this.description,
    required this.child,
    this.footer
  });

  @override
  Widget build(BuildContext context) {
    //TODO ask for /me

    return Wrap(
      spacing: 50,
      children: [
        SizedBox(
          width: 300,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headline4),
                Text(description),
              //  Expanded(child: Container(),)
              ],

            ),
        ),
         SizedBox(
           width: 1000,
           child: Card(
                color: Colors.black38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: defaultPadding, left: defaultPadding),
                        child: child
                    ),
                    CardFooter(
                      child: footer ?? Container()
                    )
                  ],
                ),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
              ),
         )
      ]
    );
  }
}

class CardFooter extends StatelessWidget {
  final Widget child;

  const CardFooter({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            Expanded(child: Container()),
            child
          ],
        ),
      ),
    );
  }
}
