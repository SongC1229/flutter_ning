import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'config.dart';
import 'page_home.dart';
import 'page_note.dart';
import 'page_grade.dart';
import 'page_sign.dart';
void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _currentIndex = 0;
  Widget _pages;
  Widget _tabBar;


  void initWidget(){
    _pages =  IndexedStack(
      children: <Widget>[
        SignPage(refreshApp:refreshApp),
        ClassPage(refreshApp: refreshApp),
        GradePage(),
        NotePage()
      ],
      index: _currentIndex,
    );
    _tabBar=CupertinoTabBar(
      activeColor: Colors.blueAccent,
      backgroundColor: Config.dark == true ?Colors.white70:Colors.white,
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: Icon(Icons.account_box,size: 23.0),
          title: Text(Config.barCate[0],style: TextStyle(fontFamily:Config.font,fontSize: 14.0),),
        ),
        new BottomNavigationBarItem(
          icon:  Icon(Icons.camera,size: 23.0),
          title: Text(Config.barCate[1],style: TextStyle(fontFamily: Config.font,fontSize: 14.0),),

        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.assessment,size: 23.0),
          title: Text(Config.barCate[2],style:TextStyle(fontFamily: Config.font,fontSize: 14.0),),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.local_offer,size: 23.0),
          title:Text(Config.barCate[3],style:TextStyle(fontFamily: Config.font,fontSize: 14.0),),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        this.setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  void refreshConf(){
    setState(() {
    });
  }


  refreshApp(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    initWidget();
    return  MaterialApp(
      theme: Config.themeData,
      home: Scaffold(
        body: _pages,
        bottomNavigationBar: _tabBar,
        backgroundColor: Config.appBackground,
      ),
    );

  }
}
