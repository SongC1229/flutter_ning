import 'package:flutter/material.dart';
import 'config.dart';
import 'dbHelper.dart';


 List<Note> _notes = [
  Note(
    tag: 1,
    datetime: '1-1\n9:59',
    title: "电路考试",
    content: '1～11章节，元月121～11章节，元月12号教室航海楼某某教室1～11章节，元月12号教室航海楼某某教室号教室航海楼某某教室',
  ),
  Note(
    tag: 2,
    datetime: '12-30\n23:25',
    title: "电路考试",
    content: '1～11章 室',
  ),
  Note(
    tag: 3,
    datetime: '12-28\n11:15',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海教室航海教室航海楼某某教室',
  ),
  Note(
    tag: 2,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
  Note(
    tag: 1,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
  Note(
    tag: 2,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
  Note(
    tag: 1,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
  Note(
    tag: 2,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
  Note(
    tag: 3,
    datetime: '12-27\n14:59',
    title: "电路考试",
    content: '1～11章节，元月12号教室航海楼某某教室',
  ),
];


class NotePage extends StatefulWidget {
  NotePage({Key key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}




class _NotePageState extends State<NotePage> {
  void _addNote() {
    setState(() {
      _notes.add(  Note(
        tag: 3,
        datetime: '12-27\n14:59',
        title: "电路考试",
        content: '1～11章节，元月12号教室航海楼某某教室',
      ));
    });
  }

  Widget _buildItem(BuildContext context, Note note) {

    Widget tagIcon=Icon(note.tag==1?Icons.beach_access:Icons.brightness_7,size: 25.0,color:note.tag==1?Colors.lightBlue:Colors.orange,);
    if(note.tag==3)
      tagIcon=Icon(Icons.wb_cloudy,size: 25.0,color:Colors.purpleAccent);
    return Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 15),),
          Container(
            width: 45,
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
              color:Config.containBkg
            ),
            child:Text(note.datetime,maxLines: 2,style: new TextStyle(fontSize: 12),textAlign: TextAlign.center,),
          ),
          Padding(padding: EdgeInsets.only(left: 10),),
          Column(children: <Widget>[
            Container(
              color: Config.lineColors,
              width: 2,
              height: 30,
            ),
            tagIcon,
            Container(
              color:Config.lineColors,
              width: 2,
              height: 45,
            ),
          ],
          ),
          Padding(padding: EdgeInsets.only(left: 15),),
          Expanded(
            child:Container(
              width: double.infinity,
              height: 85,
            padding: EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                color:Config.containBkg
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(note.title,maxLines: 1,style: new TextStyle(fontSize: 16)),
                Padding(
                  padding: EdgeInsets.only(left: 5.0,right: 5.0),
                  child:Text(note.content,maxLines: 2,overflow:TextOverflow.ellipsis,style: new TextStyle(fontSize: 14)),
                )
              ],
            ),
          ),
          ),
          Padding(padding: EdgeInsets.only(right: 15),),
        ],
      );
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Config.appBackground,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 2,
              primary: false,
              actions: <Widget>[
                Icon(Icons.settings,size: 30,)
              ],
              backgroundColor: Colors.blue,
              expandedHeight: 180.0,
              //bottom:_buildBarBottom() ,
              flexibleSpace: new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image:ExactAssetImage("asset/topBack.jpg"),
                      fit: BoxFit.cover
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width:150 ,
                        child:Text("但愿人长久，千里共婵娟",overflow: TextOverflow.ellipsis,maxLines: 2,style: new TextStyle(fontSize:13,)),
                    )
                  ],
                ),
              ),
              floating: false,
              snap: false,
              pinned: true,
            ),
            SliverFixedExtentList(
              itemExtent: 100.0,
              delegate: SliverChildListDelegate(
                _notes.map((product) {
                  return _buildItem(context,product);
                }).toList(),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 2,
          highlightElevation: 4,
          onPressed: _addNote,
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.cyan,
          mini: true,
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
}

