import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';
import 'mydrawer.dart';

class SignPage extends StatefulWidget {
  
  SignPage({this.refreshApp});
  final refreshApp;
  
  @override
  _SignPageState createState() => new _SignPageState();
}

class _SignPageState extends State<SignPage>{

  ClassRoomProvider classRoomProvider=ClassRoomProvider();
  StudentProvider studentProvider=StudentProvider();

  //课程列
  int _todayWeekCol;
  //课程行
  int _currentClassRow=-1;

  String tableTop='';
  List<Student> _students=[];
  List<int> todayCourses=[];

  bool isRefreshCourse=false;

  Widget _drawer;
  @override
  void initState() {
    super.initState();
    classRoomProvider.open().whenComplete((){
      studentProvider.open(classRoomProvider.db).whenComplete((){
        initCourse(refreshCourses);
      });
    });
    _drawer=MyDrawer(refreshApp: widget.refreshApp);
    DateTime now = new DateTime.now();
    int year =now.year;
    int month=now.month;
    int day =now.day;
    _todayWeekCol=getWeek(year,month,day)-1;
  }

  void getStudents(){
    if(_currentClassRow<1)
      return;
    int classID=Config.courseList[(_currentClassRow-1)*5+_todayWeekCol]["classId"];
    if(classID>0)
    studentProvider.getAll(classID).then((list){
            setState(() {
              _students.clear();
              if(list!=null)
              list.forEach((e){
                _students.add(e);
              });
            });
          });
  }

  void refreshCourses(){
    todayCourses.clear();
    setState(() {
      //当前应该显示节次
      int row=analysisCount(DateTime.now().hour);
      for(int i=8;i>0;i--){
        if(Config.courseList[(i-1)*5+_todayWeekCol]["classId"]!=-1){
          todayCourses.insert(0,i);
          if(i>=row){
            _currentClassRow=i;
          }
        }
      }
      if(todayCourses.isNotEmpty&&_currentClassRow==-1){
        _currentClassRow=todayCourses.first;
      }
      getStudents();
    });
  }

  //刷新节次和花名册
  void _select(int choice) {
    isRefreshCourse=false;
    getStudents();
    setState(() {
      _currentClassRow=choice;
    });
  }


  @override
  Widget build(BuildContext context) {
//    if(Config.courseList!=null&&Config.courseList.length==40&&isRefreshCourse)
//      refreshCourses();
    List<Widget> conList=_students.map((student) {
      return _buildItem(context,student);
    }).toList();
    conList.add(Container(height: 50,));
    DateTime now = new DateTime.now();
    int year =now.year;
    int month=now.month;
    int day =now.day;
    String courseName='';
    String className='';
    String classNumString='无课';
    if(_currentClassRow>0){
      className=Config.courseList[(_currentClassRow-1)*5+_todayWeekCol]["className"];
      courseName=Config.courseList[(_currentClassRow-1)*5+_todayWeekCol]["courseName"];
      classNumString="第$_currentClassRow节";
    }
    tableTop="$year 年 $month 月 $day 號 $classNumString\n$className $courseName";
    return
      Scaffold(
        drawer: _drawer,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child:
            AppBar(
                elevation: 2,
                centerTitle:false,
                titleSpacing: 20,
                title: Text(Config.barCate[0],style: new TextStyle(fontFamily: Config.font,)),
                actions: <Widget>[
                  // overflow menu
                  PopupMenuButton<int>(
                  child: Row(
                  children: <Widget>[
                  Icon(Icons.arrow_drop_down),
                  Text(_currentClassRow==-1?'无课':"第$_currentClassRow节",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 5.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 20),)
                  ],
                  ),
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    if(todayCourses.isEmpty){
                      return [PopupMenuItem<int>(
                        value: -1,
                        child: Text("无课",
                          style:TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                          ),
                        ),
                      )];
                    }
                    return todayCourses.map((int row) {
                      return PopupMenuItem<int>(
                        value: row,
                        child: Text("第$row节",
                          style:TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 5.0,
                          ),
                        ),
                      );
                    }).toList();
                  },
            ),
          ],
            )
        ),
        backgroundColor: Config.appBackground,
        body: CustomScrollView(
          slivers: <Widget>[
              SliverAppBar(
                elevation: 1,
                backgroundColor: Config.itemColors[0],
                primary: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image:ExactAssetImage("asset/back.jpg"),
                        fit: BoxFit.cover
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 5,top: 8),
                  child:Text(tableTop,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                 height: 66,
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

  int analysisCount(int hour){
    switch(hour){
      case 16:return 8;
      case 15:return 7;
      case 14:return 6;
      case 13:
      case 12:return 5;
      case 11:return 4;
      case 10:return 3;
      case 9:return 2;
      case 8:return 1;
      default:return 1;
    }
  }


}
