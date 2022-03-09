import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class LoginScreen extends StatelessWidget {

  static const String route = "login";


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'username',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'password',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _loginWithDiscord();
              },
                child: Text("Login with Discrod")
          )
        ],
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
