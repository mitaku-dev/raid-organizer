import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {

  static const String route = "login";

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
                      SizedBox(height: 60),
                      const RoundInput(hintText: "Email", icon: Icons.email),
                      SizedBox(height: defaultPadding),
                      const RoundInputPassword(hintText: "Password", icon: Icons.password),
                      SizedBox(height: defaultPadding),
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
                      SizedBox(height: defaultPadding),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {
                              //TODO
                            },
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
                              //TODO
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

  const RoundInput({
    required this.hintText,
    this.icon,
  });




  @override
  Widget build(BuildContext context) {
    return TextField(
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

  const RoundInputPassword({
    required this.hintText,
    this.icon,
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
