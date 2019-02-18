import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';
import 'page_addClassRoom.dart';
class ClassManagePage extends StatefulWidget {
  @override
  _ClassManagePageState createState() => new _ClassManagePageState();
}

class _ClassManagePageState extends State<ClassManagePage>{

  ClassRoomProvider classRoomProvider=ClassRoomProvider();
  List<ClassRoom> crmList=[];

  @override
  void initState() {
    super.initState();
    classRoomProvider.open().whenComplete((){
      classRoomProvider.getAll().then((lists){
        setState(() {
          lists.forEach((e){
            crmList.add(e);
          });
        });
      });
    });
  }

  void refresh(){
    crmList.clear();
    classRoomProvider.getAll().then((lists){
      setState(() {
        lists.forEach((e){
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
                icon: Icon(Icons.add,size:30,color: Colors.white),
                highlightColor: Colors.transparent,
                onPressed: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AddClassPage();
                      });
                }
            )
          ],
          )
      ),
      backgroundColor:Config.appBackground,
      body: ListView(
        children: crmList.map((crm){
              return _buildItem(crm);
            }).toList(),
      )
    );
  }

  Widget _buildItem(ClassRoom crm){
    return Container(
      color: Config.containBkg,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 8),
      child:
          Row(
            children: <Widget>[
              Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(crm.name,style: TextStyle(fontSize: 18),textAlign: TextAlign.left,),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("位置："+crm.site,textAlign: TextAlign.left,),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text("总人数："+crm.sum.toString(),textAlign: TextAlign.left,),
                          flex: 1,
                        )
                      ],
                    )
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  child: IconButton(
                      icon: Icon(Icons.edit,size:30,color: Colors.lightBlue),
                      highlightColor: Colors.transparent,
                      onPressed: (){
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
              )

            ],

          )
    );
  }
}
