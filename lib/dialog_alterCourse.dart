import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';
class CourseDialog extends StatefulWidget {
  const CourseDialog({@required this.index});
  final index;
  @override
  _CourseDialogState createState() => new _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog>{

  List<ClassRoom> crmList = [];
  String courseName='';
  int classId=-1;
  @override
  void initState() {
    super.initState();
      DataProvider.classRoomProvider.getAll().then((lists) {
        setState(() {
          if(lists!=null)
          lists.forEach((e) {
            crmList.add(e);
          });
        });
      });
  }

  void _updateCourse(int index,int classId,String courseName){

    setState(() {
      bool havaId=false;
      crmList.forEach((e){
        if(e.id==classId){
          print('update this course');
          havaId=true;
          //更新文件
          DataProvider.courseList[index]['courseName']=courseName;
          DataProvider.courseList[index]['classSite']=e.site;
          DataProvider.courseList[index]['className']=e.name;
          DataProvider.courseList[index]['classId']=classId;
          DataProvider.updateCourseToFile();
        }
      });
      if(!havaId){
        print("set this course empty");
        DataProvider.courseList[index]['courseName']='';
        DataProvider.courseList[index]['classSite']='';
        DataProvider.courseList[index]['className']='';
        DataProvider.courseList[index]['classId']=-1;
        DataProvider.updateCourseToFile();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height:290.0,
          child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              color: Config.itemColors[1],
            ),
            child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildTop(),
                      new Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        color:Colors.black54,
                        height: 1.5,
                      ),

                      new Container(
                        width: 250,
                        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                        padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                          color: Config.itemColors[0],
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text("班级：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily:Config.font
                            ),
                          ),
                          TextField(
                              onChanged: (num){//输入监听
                                classId=int.parse(num);
                              },
                              keyboardType: TextInputType.number,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText: '班级id',
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Config.font,

                              ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Text("课程：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                               courseName=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText:"课程名称",
                              ),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.font
                            ),
                          ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.end ,
                        children: <Widget>[
                          new FlatButton(
                            child:new Text("确定",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Config.font
                              ),
                            ),
                            color: Colors.lightBlue,
                            onPressed: (){
                                _updateCourse(widget.index,classId,courseName);
                               Navigator.of(context).pop();
                            },),

                          Padding(padding: EdgeInsets.only(left: 10.0),),
                          new FlatButton(
                            child:new Text("取消",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Config.font
                              ),
                            ),
                            color: Colors.lightBlue,
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          Padding(padding: EdgeInsets.only(left: 15.0),),
                          ],
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTop(){
    return new Container(
      height:30,
      margin:const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
      child:Row(children: <Widget>[
        Container(width:30.0,child:Icon(Icons.loyalty,color: Colors.cyan)),
        Container(
          width:170,
          child:new Align(
            alignment:FractionalOffset.centerLeft,
            child: new Text(" 添加课程",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 5.0,
                  fontFamily: Config.font
              ),
            ),
          ),
        ),
        Container(
          width: 60,
          child:FloatingActionButton(
            onPressed: (){
              Navigator.pop(context); //关闭对话框
            },
            tooltip: '关闭',
            backgroundColor: Colors.red,
            child: new Icon(Icons.close),
          ),
        ),
      ],
      ),
    );
  }

}


