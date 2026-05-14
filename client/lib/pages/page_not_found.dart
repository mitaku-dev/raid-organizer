import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  final String? name;

  const PageNotFound({Key? key, required this.name}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("404"),
        ),
        Center(
          child: Text("page "+ (name ?? "unknown") +" not found"),
        )
      ],
    );
  }
}
