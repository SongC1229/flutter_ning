import 'package:flutter/material.dart';
import 'config.dart';
import 'dialog_alterCourse.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => new _CoursePageState();
}

class _CoursePageState extends State<CoursePage>{

  List<String> classSite=[];
  List<String> courseName=[];
  @override
  void initState() {
    super.initState();
    for(int i=0;i<40;i++){
      classSite.add("");
      courseName.add("");
    }
    initCourse(refresh);
  }

  void refresh(){
    setState(() {
      print("加载完成");
    }
    );
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
      body:Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image:ExactAssetImage("asset/coursebkg.jpg"),
              fit: BoxFit.cover
          ),
        ),
        child:
        Column(
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
            child: Text("周一",textAlign: TextAlign.center,style:TextStyle(fontSize: 16),),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周二",textAlign: TextAlign.center,style:TextStyle(fontSize: 16),),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周三",textAlign: TextAlign.center,style:TextStyle(fontSize: 16),),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("周四",textAlign: TextAlign.center,style:TextStyle(fontSize: 16),),
          ),
        ) ,
        Expanded(
          child:Container(
            padding: EdgeInsets.only(top: 4,bottom: 3),
            child: Text("周五",textAlign: TextAlign.center,style:TextStyle(fontSize: 16),),
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
    String courseName='';
    String classSite='';
    if(Config.courseList.length==40) {
      classSite = Config.courseList[row * 5 + col]["classSite"];
      courseName = Config.courseList[row * 5 + col]["courseName"];
    }
    return
          Expanded(
            child:GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CourseDialog(index:row * 5 + col);
                    }).then((val){
                      setState(() {

                      });
                });
              },
            child:Container(
              height: 84,
              padding: EdgeInsets.only(top: 2,bottom: 2),
              margin: EdgeInsets.only(left: 2.0,right: 2.0),
              child: Text(courseName+classSite,textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  color:courseName+classSite==""?Config.itemColors[col]:Config.itemColors[col]
              ),
            ),
        )
      );
  }
}
