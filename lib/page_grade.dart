import 'package:flutter/material.dart';
import 'config.dart';

class GradePage extends StatefulWidget {
  @override
  _GradePageState createState() => new _GradePageState();
}

class _GradePageState extends State<GradePage>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("課堂"),),
      backgroundColor:Config.appBackground,
      body: Column(children: <Widget>[
        Text("Waiting")
      ],)
    );
  }


}
