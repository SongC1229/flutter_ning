import 'package:flutter/material.dart';
import 'config.dart';
class AddStudentDialog extends StatefulWidget {
  const AddStudentDialog({@required this.addStudent});
  final addStudent;
  @override
  _AddStudentDialogState createState() => new _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog>{

  String studentName='';
  int studentID=-1;
  int studentSex=0;

  @override
  Widget build(BuildContext context) {
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height:300.0,
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
                      new Container(
                        height:30,
                        margin:const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
                        child:Row(children: <Widget>[
                          Container(width:30.0,child:Icon(Icons.loyalty,color: Colors.cyan)),
                          Container(
                            width:170,
                            child:new Align(
                              alignment:FractionalOffset.centerLeft,
                              child: new Text(" 學生",
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
                      ),
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
                          Text("學號：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily:Config.font
                            ),
                          ),
                          TextField(
                              onChanged: (num){//输入监听
                                studentID=int.parse(num);
                              },
                              keyboardType: TextInputType.number,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText: '選填',
                              ),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Config.font,

                              ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Text("姓名：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                               studentName=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText:"姓名",
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
//                              widget.addStudent(Student(seatId: studentID,name: studentName,sex: studentSex));
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
}


