import 'dart:io';
import 'dart:convert';
//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dbHelper.dart';

class Config {
  static bool dark = false;
  static ThemeData themeData = new ThemeData(primarySwatch:Colors.blue);
  static String font="方正楷体";
  static List<Color> itemColors=[Color(0xFF99CCFF),Color(0xFFD6D5B7),Color(0xFF00E9A4),
                                  Color(0xFFFF99CC),Color(0xFFB19072)];
  static Color containBkg=Colors.white;
  static Color lineColors=Color(0xFFD3D6D8);
  static Color appBackground=Color(0xFFF5F5F5);
  static List<String> fontNames=["方正楷体","安卓系统"];
  static List<String> barCate = ['花名冊','課堂', '成績單', '便箋'];
  static List<String> courseTime=['一\n8:10\n～9:00','二\n9:10\n～10:00','三\n10:10～11:00',
  '四\n11:10～12:00','五\n13:10～14:00','六\n14:10～15:00',
  '七\n15:10～16:00','八\n16:10～17:00'];
  static List<String> weekDays=['星期日','星期一','星期二','星期三','星期四','星期五','星期六'];
}

class GlobalData{

  static ClassRoomProvider classRoomProvider=ClassRoomProvider();
  static StudentProvider studentProvider=StudentProvider();

  static bool isWrite=false;
  static String courseJsonPath;
  static List<Map> courseList=[];
  static List<int> todayCourseList=[];
  static List<Student> shouldStudents=[];
  static int shouldClassRow=-1;//可视的行
  static int todayWeek=-1;//可视的星期
  static bool coursesChange=false;

  static int getWeek(int year,int month,int day){
    if(month==1||month==2){
      year-=1;
      month+=12;
    }
    return (day+2*month+3*(month+1)~/5+year+year~/4-year~/100+year~/400+1)%7;
  }

  static int analysisNow(int hour){
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
  
  static Future initCourse() async{
    if(courseList!=null&&courseList.length==40)
      return;
    if(courseJsonPath==null){
      courseJsonPath = (await getApplicationDocumentsDirectory()).path+"/course.json";
    }
    bool courseExist=FileSystemEntity.isFileSync(courseJsonPath);
    if(!courseExist){
      for (int i=0;i<40;i++){
        courseList.add({"classId":-1,"classSite":"","className":"","courseName":""});
      }
      JsonEncoder encoder=new JsonEncoder();
      String jsonString=encoder.convert(courseList);
      new File(courseJsonPath).writeAsString(jsonString);
    }
    else {
      await File(courseJsonPath).readAsString().then((value){
        courseList.clear();
        JsonDecoder decoder = new JsonDecoder();
        List<dynamic> courseJson = decoder.convert(value);
        courseJson.forEach((e){
          courseList.add(e);
        });
      });
    }
  }

  static void initTodayCourse(){
    todayCourseList.clear();
    //当前应该显示节次
    DateTime now = new DateTime.now();
    int year =now.year;
    int month=now.month;
    int day =now.day;
    int row=analysisNow(now.hour);
    todayWeek=getWeek(year,month,day);
    for(int i=8;i>0;i--){
      if(courseList[(i-1)*5+todayWeek-1]["classId"]!=-1){
        todayCourseList.insert(0,i);
        if(i>=row){
          shouldClassRow=i;
        }
      }
    }
    if(todayCourseList.isNotEmpty&&shouldClassRow==-1){
      shouldClassRow=todayCourseList.first;
    }
  }

  //初始化当天信息
  static Future initGlobalData() async{
    //读取json文件 初始化课程表
    await initCourse().whenComplete(() async{
      //初始化courseList完成
      print("Load course.json finish");
      initTodayCourse();
      print("Init today course finish");
      await classRoomProvider.open().whenComplete(() async{
        await studentProvider.open(classRoomProvider.db);
      });
      print("Start database finish");
      await getShouldStudents();
      print("Get Should Students finish");
    });
  }

  static Future getShouldStudents() async{
    if(shouldClassRow<1)
      return;
    int classID=courseList[(shouldClassRow-1)*5+todayWeek-1]["classId"];
    if(classID>0)
    await studentProvider.getAll(classID).then((list){
              shouldStudents.clear();
              if(list!=null)
              list.forEach((e){
                shouldStudents.add(e);
              });
    });
  }

  static void updateCourseToFile() async{
    if(courseJsonPath==null){
      courseJsonPath = (await getApplicationDocumentsDirectory()).path+"/course.json";
    }
    if(!isWrite){
      isWrite=true;
      coursesChange=true;
      print("更新course.json");
      JsonEncoder encoder=new JsonEncoder();
      String jsonString=encoder.convert(courseList);
      File(courseJsonPath).writeAsString(jsonString).whenComplete((){
        isWrite=false;
      });
    }
    else{
      sleep(Duration(seconds: 1));
      updateCourseToFile();
    }
  }
  
}



