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

  Widget _drawer;
  String tableTop='';

  @override
  void initState() {
    super.initState();
    _drawer=MyDrawer(refreshApp: widget.refreshApp);
    DataProvider.initData().whenComplete((){
      setState(() {
      });
    });
  }

  //刷新节次和花名册
  void _select(int choice) {
    setState(() {
      DataProvider.showCourseRow=choice;
      DataProvider.getShowStudentsAndInitRoster().whenComplete((){
          setState(() {
          });
      });
    });
  }

  void refreshInfo()async{
    DataProvider.coursesChange=false;
    DataProvider.initTodayCourse();
    DataProvider.getShowStudentsAndInitRoster().whenComplete((){
      setState(() {
      });
    });
    }

  @override
  Widget build(BuildContext context) {
    //如果课程信息变动，刷新当天信息
    if(DataProvider.coursesChange)
      refreshInfo();
    List<Widget> conList=DataProvider.showStudents.map((student) {
      return _buildItem(context,student);
    }).toList();
    conList.add(Container(height: 50,));
    String courseName='';
    String className='';
    String classNumString='无课';
    if(DataProvider.showCourseRow>0){
      className=DataProvider.courseList[(DataProvider.showCourseRow-1)*5+DataProvider.todayWeek-1]["className"];
      courseName=DataProvider.courseList[(DataProvider.showCourseRow-1)*5+DataProvider.todayWeek-1]["courseName"];
      classNumString="第"+DataProvider.showCourseRow.toString()+"节";
    }
    tableTop=DataProvider.year.toString()+" 年 "+DataProvider.month.toString()+" 月 "+DataProvider.day.toString()+" 號 $classNumString\n$className $courseName";
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
                  Text(DataProvider.showCourseRow==-1?'无课':classNumString,
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
                    if(DataProvider.todayCourseList.isEmpty){
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
                    return DataProvider.todayCourseList.map((int row) {
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
              icon: Icon(Icons.filter_vintage,color: student.notLeave?Colors.grey[300]:Colors.blue),
              highlightColor: Colors.transparent,
              onPressed: (){
                setState(() {
                  student.notLeave=!student.notLeave;
                  student.notAbsence=student.notLeave;
                  DataProvider.updateRoster();
                });
              },
            ),
            flex: 2,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:IconButton(
              icon: Icon(Icons.bookmark,color:student.notAbsence?Colors.grey[300]:Colors.red),
              highlightColor: Colors.transparent,
              onPressed: (){
                setState(() {
                  student.notAbsence=!student.notAbsence;
                  DataProvider.updateRoster();
                });
              },
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
