import 'package:flutter/material.dart';
import 'config.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => new _CoursePageState();
}

class _CoursePageState extends State<CoursePage>{


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(title: Text("我的課程"),)
      ),
      backgroundColor:Config.containBkg,
      body: Column(
        children: <Widget>[
          _buildDay(),
          Expanded(
            child:
            CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                  itemExtent: 90.0,
                  delegate: SliverChildListDelegate(
                      _buildCourse()
                  ),
                )
                ,
              ]
            )

          ),
        ],
      )
    );
  }

  Widget _buildDay(){
    return Row(

      children: <Widget>[
        Container(
            width: 40,
        ),
        Expanded(
          child:Container(
            child: Text("周一",textAlign: TextAlign.center,),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周二",textAlign: TextAlign.center,),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周三",textAlign: TextAlign.center,),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周四",textAlign: TextAlign.center,),
          ),
        ) ,
        Expanded(
          child:Container(
            padding: EdgeInsets.only(top: 4,bottom: 3),
            child: Text("周五",textAlign: TextAlign.center,),
          ),
        ),
    ],
    );
  }

  List<Widget> _buildCourse() {
    List<Widget> table=[];
    for (int i=0;i<8;i++){
      table.add(_buildRow(i));
    }
    return table;
  }

  Widget _buildRow(int row){
    return  Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 2),
          width: 40,
          child: Text(Config.courseTime[row],textAlign:TextAlign.center,),
        ),
        _buildItem(row, 0),
        _buildItem(row, 1),
        _buildItem(row, 2),
        _buildItem(row, 3),
        _buildItem(row, 4),
    ]
  );
  }

  Widget _buildItem(int row,int col){
    return  Expanded(
      child:Container(
        height: 84,
        padding: EdgeInsets.only(top: 2,bottom: 2),
        margin: EdgeInsets.only(left: 2.0,right: 2.0),
        child: Text(Config.weekDaysTwo[col],textAlign: TextAlign.center,),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
            color:row-col==0?Colors.transparent:Config.itemColors[col]
        ),
      ),
    );
  }
}
