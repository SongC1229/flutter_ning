import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';

class AddClassPage extends StatefulWidget {
  AddClassPage({this.classroom,this.refreshManage});
  final refreshManage;
  final classroom;
  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  
  ClassRoom classRoom=ClassRoom(id:null,name: '',site: '',sum: -1);
  List<Student> _students=[];
  String barTitle="添加班级";
  @override
  void initState() {
    super.initState();
        //更新班级
        if(widget.classroom!=null){
          classRoom=widget.classroom;
          barTitle='修改班级';
          DataProvider.studentProvider.getAll(classRoom.id).then((list){
            setState(() {
              list.forEach((e){
                _students.add(e);
              });
            });
          });
        }
        //新建班级
        else {
          setState(() {
            for (int i = 1; i <= 60; i++) {
              _students.add(Student(seatId: i, sex: 1, name: "", average: 100));
            }
          });
        }
  }



  void _addStudent() {
    setState(() {
      _students.add(Student(seatId: _students.last.seatId+1,name: "",sex: 0,average: 100));
    });
  }

  void _saveClass(){
    int sum=0;
    _students.forEach((student){
      if(student.name!=""){
        sum+=1;
      }
    });
    classRoom.sum=sum;
    //更新
    if(classRoom.id!=null){
      //更新课程表
      DataProvider.courseList.forEach((course){
        if(course["classID"]==classRoom.id){
          course["className"]=classRoom.name;
        }
      });
      DataProvider.updateCourseToFile();
      DataProvider.classRoomProvider.update(classRoom);
      print("update classroom success");
      _students.forEach((student) {
        if (student.name != "") {
          student.classId = classRoom.id;
          DataProvider.studentProvider.insert(student).then((s){
            student.id=s.id;
          });
        }
      });
      print("update students finish");
    }
    //新建班级
    else{
      DataProvider.classRoomProvider.insert(classRoom).then((cr) {
        print("insert classroom success");
        classRoom.id=cr.id;
        _students.forEach((student) {
          if (student.name != "") {
            student.classId = cr.id;
            DataProvider.studentProvider.insert(student).then((s){
              student.id=s.id;
            });
          }
        });
        print("insert students finish");
      });
    }
  }

  Future<bool> _onWillPop() {
    if(widget.refreshManage!=null){
      widget.refreshManage();
    }
    if(classRoom.id!=null){
//        Navigator.of(context).pop(false);
        return Future.value(true);
    }
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.only(left: 10),
        title: new Text("退出",style: TextStyle(fontSize: 18),),
        content: new SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: new ListBody(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5),
                color:Colors.grey,
                height: 1.5,
              ),
              new Text('尚未保存班级信息\n'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('直接退出'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('继续编辑'),
          ),
        ],
      ),
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    Widget classInfo =_buildClassInfo();
    Widget tabTop=_buildTabTop();

    List<Widget> conList=_students.map((student) {
      return _buildStudent(context,student);
    }).toList();
    conList.insert(0, tabTop);
    conList.insert(0, classInfo);
    Widget bottom=new Container(
      height: 50,
    );
    conList.add(bottom);
    return
      WillPopScope(
        onWillPop:_onWillPop,
        child:Scaffold(
        appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child:AppBar(
                  elevation: 2,
                  centerTitle:false,
                  title: Text('$barTitle',style: new TextStyle(fontFamily: Config.font,)),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.save),color: Colors.white,onPressed: (){
                      if(classRoom.name==''){
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.only(left: 10),
                            title: new Text('保存',style: TextStyle(fontSize: 18),),
                            content: new SingleChildScrollView(
                              padding: EdgeInsets.all(15),
                              child: new ListBody(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    color:Colors.grey,
                                    height: 1.5,
                                  ),
                                  new Text('班级名称不能为空\n'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('确定'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),

                            ],
                          );
                        });
                      }
                      else{
                        //保存班级信息
                        _saveClass();
                      }
                    },),
                  ],
              )
          ),
        backgroundColor: Config.appBackground,
        body: ListView(
              children:conList,
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          highlightElevation: 4,
          onPressed:(){
            _addStudent();
          },
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.cyan,
          mini: true,
        ), // This trailing comma makes auto-formatting nicer for build methods.
        )
      );
    }

  Widget _buildStudent(BuildContext context, Student student) {
    TextEditingController edtName;
    student.name==null?edtName=new TextEditingController():edtName=new TextEditingController(text: student.name);
    Widget tagIcon=Icon(Icons.person,color:student.sex==1?Colors.lightBlue:Colors.redAccent,);
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(10,0,10,1),
      padding: EdgeInsets.fromLTRB(10,0,15,0),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          color:Config.itemColors[0]
      ),
      child:Row(
        children: <Widget>[
          Expanded(
            child:IconButton(
                icon: tagIcon,
                onPressed: (){
                  setState(() {
                    student.sex==0?student.sex=1:student.sex=0;
                  });
                }
            ),
            flex: 1,
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
              child:Text(student.seatId==-1?"空":student.seatId.toString(),maxLines: 1,style: new TextStyle(fontSize: 12),textAlign: TextAlign.center,),
            ),
            flex: 1,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                  color:Config.containBkg
              ),
              child:
              TextField(
                onChanged: (name){//输入监听
                  student.name=name;
                },
                controller: edtName,
                keyboardType: TextInputType.text,//设置输入框文本类型
                textAlign: TextAlign.center,//设置内容显示位置是否居中等
                decoration: new InputDecoration(
                  hintText: '姓名',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  fontFamily: Config.font,

                ),
              ),
            ),
            flex: 3,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:IconButton(
              onPressed: (){
                setState(() {
                  _students.remove(student);
                  if(student.id!=null)
                    DataProvider.studentProvider.delete(student.id);
                });
              },
              icon: Icon(Icons.delete,color: Colors.blue,),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfo(){
    TextEditingController edtClassName;
    TextEditingController edtClassSite;
    classRoom.name==null?edtClassName=new TextEditingController():edtClassName=new TextEditingController(text:classRoom.name);
    classRoom.site==null?edtClassSite=new TextEditingController():edtClassSite=new TextEditingController(text:classRoom.site);
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          color:Config.itemColors[0]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("班级：",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                fontFamily: Config.font
            ),
          ),
          TextField(
            onChanged: (String str){//输入监听
              classRoom.name=str;
            },
            keyboardType: TextInputType.text,//设置输入框文本类型
            controller: edtClassName,
            textAlign: TextAlign.left,//设置内容显示位置是否居中等
            decoration: new InputDecoration(
              hintText: '班级名称',
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              fontFamily: Config.font,

            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0),),
          Text("教室：",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                fontFamily: Config.font
            ),
          ),
          TextField(
            onChanged: (String str){//输入监听
              classRoom.site=str;
            },
            controller: edtClassSite,
            keyboardType: TextInputType.text,//设置输入框文本类型
            textAlign: TextAlign.left,//设置内容显示位置是否居中等
            decoration: new InputDecoration(
              hintText:"班级位置",
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
    );
  }

  Widget _buildTabTop(){
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
      padding: EdgeInsets.fromLTRB(10,0,15,0),
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          color:Config.itemColors[0]
      ),
      child:Row(
        children: <Widget>[
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
//                  color:Config.containBkg
              ),
              child:Text("性 別",maxLines: 1,style: new TextStyle(fontSize:16),textAlign: TextAlign.center,),
            ),
            flex: 1,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
//                  color:Config.containBkg
              ),
              child:Text("座 號",maxLines: 1,style: new TextStyle(fontSize:16),textAlign: TextAlign.center,),
            ),
            flex: 1,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
//                  color:Config.containBkg
              ),
              child:Text('姓 名',maxLines: 1,style: new TextStyle(fontSize:16),textAlign: TextAlign.center,),
            ),
            flex: 3,
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
//                  color:Config.containBkg
              ),
              child:Text("刪 除",maxLines: 1,style: new TextStyle(fontSize:16),textAlign: TextAlign.center,),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

