import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'config.dart';
import 'page_home.dart';
import 'page_note.dart';
import 'page_grade.dart';
import 'page_sign.dart';
import 'mydrawer.dart';
import 'page_addClassRoom.dart';
void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _currentIndex = 1;
  Widget _pages;
  Widget _tabBar;
  Widget _drawer;


  void initWidget(){
    _pages =  IndexedStack(
      children: <Widget>[
        SignPage(),
        ClassPage(),
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
          icon:  Icon(Icons.home,size: 23.0),
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
  void initState() {
    super.initState();
      _drawer=MyDrawer(refreshMain: null);
  }

  @override
  Widget build(BuildContext context) {
    initWidget();
    return  MaterialApp(
      theme: Config.themeData,
      home: Scaffold(
        drawer: _drawer,
        body: _pages,
        bottomNavigationBar: _tabBar,
        backgroundColor: Config.appBackground,
      ),
    );

  }
}

class TopIcon extends StatelessWidget {
  TopIcon({@required this.cate});
  final cate;
  @override
  Widget build(BuildContext context) {
    Widget icon;
    icon=Icon(Icons.add,color:Config.itemColors[cate],);
    return  IconButton(
      icon: icon,
      highlightColor: Colors.transparent,
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AddClassPage();
            });
      },
    );
  }
}
