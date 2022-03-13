import 'package:client/controller/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {

  static const String route = "register";

  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _passwordVisible = false;
  bool _passwordVisible2 = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600, // TODO for media queries
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Text("REGISTER", style: Theme.of(context).textTheme.headline1),
                Text("Create your new account", style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 60),
                const SizedBox(height: 10,),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person)
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email)
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                    suffixIcon:  GestureDetector(
                      child: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextField(
                  controller: _password2Controller,
                  obscureText: !_passwordVisible2,
                  decoration: InputDecoration(
                    hintText: "Repeat Password",
                    prefixIcon: Icon(Icons.password),
                    suffixIcon:  GestureDetector(
                      child: Icon(
                        _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onTap: () {
                        setState(() {
                          _passwordVisible2 = !_passwordVisible2;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () => _register(context),
                      child: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text("Register", style: Theme.of(context).textTheme.button)
                      ),
                      style:  ElevatedButton.styleFrom(shape : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.lightGreen),
                      ),
                          primary: Colors.transparent
                      )
                  ),
                ),
                Expanded(
                  child: Container(),
                ),

                Text("Login with Socials"),
                SocialLogins(),
                SizedBox(height: 50),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("login");
                      },
                      child: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_arrow_left),
                              Text("Back to Login", style: Theme.of(context).textTheme.button),
                            ],
                          )
                      ),
                      style:  ElevatedButton.styleFrom(shape : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                          primary: Colors.transparent
                      )
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {

    bool success = await context.read<AuthProvider>().register(
      _usernameController.value.text,
      _emailController.value.text,
      _passwordController.value.text,
      _password2Controller.value.text
    );

    if(success) {
      Navigator.of(context).pushNamed("home");
    }

  }

}