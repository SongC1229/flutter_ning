import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';
import 'page_addClass.dart';
class ClassManagePage extends StatefulWidget {
  @override
  _ClassManagePageState createState() => new _ClassManagePageState();
}

class _ClassManagePageState extends State<ClassManagePage> {

  ClassRoomProvider classRoomProvider = ClassRoomProvider();
  List<ClassRoom> crmList = [];

  @override
  void initState() {
    super.initState();
    classRoomProvider.open().whenComplete(() {
      classRoomProvider.getAll().then((lists) {
        setState(() {
          lists.forEach((e) {
            crmList.add(e);
          });
        });
      });
    });
  }

  void _refresh() {
    crmList.clear();
    classRoomProvider.getAll().then((lists) {
      setState(() {
        lists.forEach((e) {
          crmList.add(e);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        PreferredSize(
            preferredSize: Size.fromHeight(45.0),
            child: AppBar(title: Text("我的班级"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.add, size: 30, color: Colors.white),
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AddClassPage(refreshManage: _refresh,);
                          });
                    }
                )
              ],
            )
        ),
        backgroundColor: Config.appBackground,
        body: ListView(
          children: crmList.map((crm) {
            return _buildItem(crm);
          }).toList(),
        )
    );
  }

  Widget _buildItem(ClassRoom crm) {
    return Container(
        color: Config.containBkg,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 8),
        child:
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(crm.name, style: TextStyle(fontSize: 18), textAlign: TextAlign.left,),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("ID："+crm.id.toString(), textAlign: TextAlign.left,),
                        flex: 1,
                      )
                    ],
                  ),

                  Padding(padding: EdgeInsets.only(top: 5),),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "班级位置：" + crm.site, textAlign: TextAlign.left,),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("总人数：" + crm.sum.toString(),
                          textAlign: TextAlign.left,),
                        flex: 1,
                      )
                    ],
                  )
                ],
              ),
              flex: 4,
            ),
            Expanded(
              child: Container(
                  child: IconButton(
                      icon: Icon(
                          Icons.delete_forever, size: 30, color:Config.itemColors[4]),
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return _buildAlterDialog(crm.name);
                            }).then((val) {
                          if (val == true){
                            //删除相关课程
                            Config.courseList.forEach((e){
                              if(e['classId']==crm.id){
                                e['classId']=-1;
                                e['courseName']='';
                                e['classSite']='';
                              }
                            });
                            updateCourseToFile();
                            //删除班级
                            classRoomProvider.delete(crm.id).whenComplete(() {
                              _refresh();
                            });
                          }
                        }
                        );
                      }
                  )
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                  child: IconButton(
                      icon: Icon(Icons.edit, size: 30, color: Colors.lightBlue),
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AddClassPage(classroom: crm);
                            });
                      }
                  )
              ),
              flex: 1,
            ),
          ],

        )
    );
  }

  Widget _buildAlterDialog(String crmName) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 10),
      title: new Text("删除班级", style: TextStyle(fontSize: 18),),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: new SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: new ListBody(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              color: Colors.grey,
              height: 1.5,
            ),
            new Text('相关课程将同时清除：\n    $crmName',style: TextStyle(height: 1.3),),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('删除'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        new FlatButton(
          child: new Text('取消'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),

      ],
    );
  }

}
