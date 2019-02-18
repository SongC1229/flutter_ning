import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';
import 'main.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => new _SignPageState();
}

class _SignPageState extends State<SignPage>{

  ClassRoomProvider classRoomProvider=ClassRoomProvider();
  StudentProvider studentProvider=StudentProvider();
  int classId=1;
  String className='';
  String courseName='';
  List<Student> _students=[];


  @override
  void initState() {
    super.initState();
    classRoomProvider.open().whenComplete((){
      classRoomProvider.getMaxId().then((result){
        classId=result;
        classRoomProvider.getClassRoom(classId).then((cr){
          setState(() {
            className=cr.name;
            courseName="数学";
          });
        });
        studentProvider.open(classRoomProvider.db).whenComplete((){
          studentProvider.getAll(classId).then((list){
            setState(() {
              list.forEach((e){
                _students.add(e);
              });
            });
          });
        });
      });

    });
    
  }

  int analysisCount(int hour,int min){
    switch(hour){
      case 17:return 9;break;
      case 16:return 8;break;
      case 15:return 7;break;
      case 14:return 6;break;
      case 13:return 5;break;
      case 12:return 5;break;
      case 11:return 4;break;
      case 10:return 3;break;
      case 9:return 2;break;
      case 8:return 1;break;
      default:return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> conList=_students.map((student) {
      return _buildItem(context,student);
    }).toList();
    conList.add(Container(height: 50,));
    DateTime now = new DateTime.now();
    int year =now.year;
    int month=now.month;
    int day =now.day;
    int hour=now.hour;
    int min=now.minute;
    int count=analysisCount(hour,min);
    return
      Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child:
            AppBar(
                elevation: 2,
                centerTitle:false,
                titleSpacing: 20,
                title: Text(Config.barCate[0],style: new TextStyle(fontFamily: Config.font,)),
                actions: <Widget>[
                  // action button
                  TopIcon(cate: 0),
                ]
            )
        ),
        backgroundColor: Config.appBackground,
        body: CustomScrollView(
          slivers: <Widget>[
              SliverAppBar(
                elevation: 1,
                backgroundColor: Config.appBackground,
                primary: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image:ExactAssetImage("asset/back.jpg"),
                        fit: BoxFit.cover
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 5,top: 5),
                  child:Card(
                    margin: EdgeInsets.all(0),
                    color: Config.itemColors[0],
                    elevation: 2,
                    child:Text("$year 年 $month 月 $day 號 第 $count 节 \n某班级 某课程",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                  ),
                 height: 50,
                ),
                bottom:_buildTabTop() ,
                floating: false,
                snap: false,
                pinned: true,
              ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildListDelegate(
                conList
              ),
            )
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
  
  Widget _buildItem(BuildContext context, Student student) {
    Widget tagIcon=Icon(Icons.person,color:student.sex==1?Colors.lightBlue:Colors.redAccent,);
    return Container(
      margin: EdgeInsets.fromLTRB(0,4,0,0),
      padding: EdgeInsets.fromLTRB(10,0,15,0),
      color: Config.containBkg,
      child:Row(
        children: <Widget>[
          Expanded(
            child:tagIcon,
            flex: 2,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 14),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  color:Config.containBkg
              ),
              child:Text(student.seatId==-1?"空":student.seatId.toString(),maxLines: 1,style: new TextStyle(fontSize: 14),textAlign: TextAlign.center,),
            ),
            flex:2,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  color:Config.containBkg
              ),
              child:Text(student.name,maxLines: 1,style: new TextStyle(fontSize: 16),textAlign: TextAlign.center,),
            ),
            flex: 5,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:IconButton(
              onPressed: (){
                setState(() {
                  _students.remove(student);
                });
              },
              icon: Icon(Icons.home,color: Colors.grey[300],),
            ),
            flex: 2,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:IconButton(
              onPressed: (){
                setState(() {
                  _students.remove(student);
                });
              },
              highlightColor: Colors.transparent,
              icon: Icon(Icons.favorite_border,color: Colors.red,),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTabTop(){
    return
      PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
        padding: EdgeInsets.fromLTRB(10,0,15,0),
        color: Config.containBkg,
        child:Row(
          children: <Widget>[
            Expanded(
              child:Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color: Config.containBkg
                ),
                child:Text("性別",maxLines: 1,style: new TextStyle(fontSize:16,letterSpacing: 4),textAlign: TextAlign.center,),
              ),
              flex: 2,
            ),
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child:Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color:Config.containBkg
                ),
                child:Text("座號",maxLines: 1,style: new TextStyle(fontSize:16,letterSpacing: 5),textAlign: TextAlign.center,),
              ),
              flex: 2,
            ),
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child:Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color:Config.containBkg
                ),
                child:Text('姓名',maxLines: 1,style: new TextStyle(fontSize:16,letterSpacing: 5),textAlign: TextAlign.center,),
              ),
              flex: 5,
            ),
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child:Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color:Config.containBkg
                ),
                child:Text("请假",maxLines: 1,style: new TextStyle(fontSize:16,letterSpacing: 5),textAlign: TextAlign.center,),
              ),
              flex: 2,
            ),
            Padding(padding: EdgeInsets.only(left: 15),),
            Expanded(
              child:Container(
                height: 40,
                padding: EdgeInsets.only(top: 10),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                    color:Config.containBkg
                ),
                child:Text("缺勤",maxLines: 1,style: new TextStyle(fontSize:16,letterSpacing: 5),textAlign: TextAlign.center,),
              ),
              flex: 2,
            ),
          ],
        ),
      )
      );
  }
}
