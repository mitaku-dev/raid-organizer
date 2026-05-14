import 'package:client/pages/static_screen.dart';
import 'package:flutter/material.dart';

import '../../model/static.dart';
import '../../service/http_service.dart';

class MyStaticsPage extends StatefulWidget {
  MyStaticsPage({Key? key}) : super(key: key);

  @override
  _MyStaticsPageState createState() => _MyStaticsPageState();
}

class _MyStaticsPageState extends State<MyStaticsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: HttpService().getMyStatics(),
            builder: (context, AsyncSnapshot<List<Static>> snapshot) {
              List<Static> statics = snapshot.data ?? List.empty();
              // statics = [...newStatics,...statics];

              return  Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: statics.map((el) => StaticCard(static: el)).toList()
                  ),
                ),
              );
            }
        )
      ],
    );
  }
}