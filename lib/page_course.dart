import 'package:flutter/material.dart';
import 'config.dart';
import 'dialog_alterCourse.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => new _CoursePageState();
}

class _CoursePageState extends State<CoursePage>{

  @override
  void initState() {
    super.initState();
//    initCourse(refresh);
  }

  void refresh(){
    setState(() {
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
            _buildTop(),
            Expanded(
              child:
              CustomScrollView(
                slivers: <Widget>[
                  SliverFixedExtentList(
                    itemExtent: 75.0,
                    delegate: SliverChildListDelegate(
                        _buildTable()
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

  Widget _buildTop(){
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

  List<Widget> _buildTable() {
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
          child: Text(Config.courseTime[row],style: TextStyle(fontSize: 12),textAlign:TextAlign.center,),
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
    String className='';
    if(GlobalData.courseList.length==40) {
      classSite = GlobalData.courseList[row * 5 + col]["classSite"];
      courseName = GlobalData.courseList[row * 5 + col]["courseName"];
      className = GlobalData.courseList[row * 5 + col]["className"];
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
              height: 71,
              padding: EdgeInsets.only(top: 2,bottom: 2),
              margin: EdgeInsets.only(left: 3.0,right: 3.0),
              child: Text("$courseName\n$classSite\n$className",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 12),),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  color:courseName+classSite==""?Colors.transparent:Config.itemColors[col]
              ),
            ),
        )
      );
  }
}
