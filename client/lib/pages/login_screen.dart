import 'package:client/constants.dart';
import 'package:client/controller/auth_provider.dart';
import 'package:client/controller/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {

  static const String route = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  var _loginError = false;

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
                      Text("LOGIN", style: Theme.of(context).textTheme.headline1),
                      Text("Please enter your login and password", style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 60),

                      //TODO animate
                      Visibility(
                          visible: _loginError,
                          child: const Text(
                            "Password or username is incorrect",
                            style: TextStyle(
                                color: Colors.red
                            ),
                          )
                      ),
                      SizedBox(height: 10,),
                      RoundInput(hintText: "Email", icon: Icons.email, controller: _usernameController),
                      const SizedBox(height: defaultPadding),
                      RoundInputPassword(hintText: "Password", icon: Icons.password, controller: _passwordController),
                      const SizedBox(height: defaultPadding),

                      //TODO forgot passiwr
                      TextButton(
                          onPressed: (){},
                          child: const Text(
                              "Forgot password",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline
                            ),
                          )
                      ),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () => _login(context),
                            child: Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Text("Login", style: Theme.of(context).textTheme.button)
                            ),
                            style:  ElevatedButton.styleFrom(shape : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.lightGreen),
                            ),
                              primary: Colors.transparent
                            )
                          ),
                      ),
                      SizedBox(height: defaultPadding*2),
                      SocialLogins(),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("register");
                            },
                            child: Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Register", style: Theme.of(context).textTheme.button),
                                    Icon(Icons.arrow_right_alt)
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

  _login(BuildContext context) async {
    setState(() {
      _loginError = false;
    });

    bool sucess = await context.read<AuthProvider>().login(_usernameController.value.text, _passwordController.value.text);
    if(!sucess) {
      setState(() {
        _loginError = true;
      });
    }else {
      context.read<MenuController>().pushNamed(HomeScreen.route);
    }
    //TODO on error
    _usernameController.clear();
    _passwordController.clear();
  }

  _loginWithDiscord()  async{
    // Present the dialog to the user

    final result = await FlutterWebAuth.authenticate(url: "http://192.168.178.75:8080/oauth2/authorization/discord", callbackUrlScheme: "http");

    print(result);

// Extract token from resulting url
    final token = Uri.parse(result).queryParameters['token'];
  }
}

class RoundInput extends StatelessWidget {

  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;

  const RoundInput({
    required this.hintText,
    this.icon,
    this.controller
  });




  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon  != null ?  Icon(icon, color: Colors.white54) : null,
        suffixIcon: const Icon(Icons.visibility, color: Colors.transparent),
        contentPadding: EdgeInsets.all(0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.blueAccent)
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blueAccent)
        ),
        fillColor: Colors.white70,
        hintText: hintText,
      ),
        textAlign: TextAlign.center,

    );
  }
}


class SocialLogins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SocialLoginIcon(icon: FontAwesomeIcons.discord, color: Colors.blue, action: () {}),
            SizedBox(width: 30,),
            SocialLoginIcon(icon: FontAwesomeIcons.google, color: Colors.red, action: () {})
        ],
    );
  }
}


class SocialLoginIcon extends StatelessWidget {

  final IconData icon;
  final VoidCallback action;
  final Color color;

  const SocialLoginIcon({
    required this.icon,
    required this.action,
    this.color = Colors.white54
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon, color: color),
      onPressed: action
    );
  }
}


class RoundInputPassword extends StatefulWidget {

  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;

  const RoundInputPassword({
    required this.hintText,
    this.icon,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => RoundInputPasswordState();

}


class RoundInputPasswordState extends State<RoundInputPassword> {

  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        prefixIcon: widget.icon  != null ?  Icon(widget.icon, color: Colors.white54) : null,
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
        contentPadding: EdgeInsets.all(0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blueAccent)
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blueAccent)
        ),
        fillColor: Colors.white70,
        hintText: widget.hintText,
      ),
      textAlign: TextAlign.center,

    );
  }
}
