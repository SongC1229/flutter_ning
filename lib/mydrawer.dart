import 'package:flutter/material.dart';
import 'config.dart';
import 'page_course.dart';
import 'page_classManage.dart';
class MyDrawer extends StatefulWidget {
  MyDrawer({@required this.refreshMain});
  final refreshMain;

  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child:Container(
                color: Config.appBackground,
                child: Column(children: <Widget>[
                    _userHeader(),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("签 名",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,

                        ),
                      ),
                      leading: Icon(Icons.loyalty,color: Colors.cyan,),
                      onTap:setMotto,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      leading: Icon(Icons.brightness_2,color: Colors.cyan,),
                      title: Text( "夜间",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                        ),
                      ),
                      onTap: () {
                      },
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("班級管理",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                        ),
                      ),
                      leading: Icon(Icons.account_balance,color: Colors.cyan,),
                      onTap:_showClassManage,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("我的課程",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,

                        ),
                      ),
                      leading: Icon(Icons.apps,color: Colors.cyan),
                      onTap:_showMyCourse,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    new ListTile( //退出按钮
                        leading: Icon(Icons.info,color: Colors.cyan,),
                        title: new Text('关 于',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 5.0,
                          ),
                        ),
                        onTap: _aboutPage
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                  ],
                  )
                )
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child:Container(
              child:new Align(
                alignment:FractionalOffset.center,
                child: new Text("☺  https://github.com/Sningi",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )
          ),

        ],
      ),
    );
  }

  Widget _userHeader(){
    return UserAccountsDrawerHeader(
      accountName: new Text('name',
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
        ),
      ), //用户名
      accountEmail: new Text('签名',
        style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.normal,
            letterSpacing: 3.0,
        ),
      ), //用户邮箱

      currentAccountPicture: new GestureDetector( //用户头像
        onTap: () => print('current user'),
        child: new CircleAvatar( //圆形图标控件
          backgroundImage: ExactAssetImage("asset/topBack.jpg"),
        ),
      ),
      decoration: BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.cover,
          // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
          //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
          image: ExactAssetImage("asset/topBack.jpg"),
        ),
      ),
      margin: EdgeInsets.only(bottom: 0.0),
    );
  }


  // 方法调用
  void _showClassManage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  ClassManagePage();
        });
  }

  void _aboutPage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ;
        });
  }

  void _showMyCourse() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CoursePage();
        });
  }

  void setMotto() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ;
        });
  }


}





