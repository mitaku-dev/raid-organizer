import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {

  TextEditingController? controller;
  IconData? prefixIcon;
  String? hintText;
  TextStyle? style;

  PasswordInput({
    Key? key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.style,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: !_passwordVisible,
      style: widget.style,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon  != null ?  Icon(widget.prefixIcon, color: Colors.white54) : null,
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
        hintText: widget.hintText,
      ),

    );
  }
}