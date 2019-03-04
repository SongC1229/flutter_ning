import 'package:sqflite/sqflite.dart';

final String dbName='/ning.db';

//table classroom
final String tableClassRoom = 'classroom';
final String classroomId = 'id';
final String classroomName = 'name';
final String classroomSite = 'site';
final String classroomSum="sum";
//table student
final String tableStudent = 'student';
final String studentId = 'id';
final String studentClassId = 'classId';
final String studentSeatId = 'seatId';
final String studentName = 'name';
final String studentSex = 'sex';
final String studentAverage="average";
//table roster
final String tableRoster = 'roster';
final String rosterDateId = 'dateId';
final String rosterClassId = 'classId';
final String rosterCourseName = 'courseName';
final String rosterSum = 'sum';
final String rosterShould = 'should';
final String rosterAlready = 'already';
final String rosterAbsence = 'absence';
final String rosterLeave= 'leave';
//table roster
final String tableNote = 'note';
final String noteId = 'id';
final String noteDatetime = 'datetime';
final String noteTag = 'tag';
final String noteTitle = 'title';
final String noteContent = 'content';

class ClassRoom {
  int id;
  String name;
  String site;
  int sum;

  ClassRoom({
    this.id,
    this.name,
    this.site,
    this.sum
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      classroomName :name,
      classroomSite :site,
      classroomSum:sum
    };
    if (id != null) {
      map[classroomId] = id;
    }

    return map;
  }

  ClassRoom.fromMap(Map<String, dynamic> map) {
    id = map[classroomId];
    name = map[classroomName];
    site = map[classroomSite];
    sum = map[classroomSum];
  }
}

class ClassRoomProvider {
  Database db;

  Future open() async {
    String path=await getDatabasesPath();
    path=path+dbName;
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table if not exists $tableClassRoom ( 
  $classroomId integer primary key autoincrement, 
  $classroomName varchar(15)  not null,
  $classroomSite varchar(15),
  $classroomSum integer)
  ''');
          await db.execute('''
create table if not exists $tableStudent ( 
  $studentId integer primary key autoincrement, 
  $studentClassId integer not null,
  $studentSeatId integer not null,
  $studentName varchar(15) not null,
  $studentSex integer not null,
  $studentAverage integer not null,
  foreign key($studentClassId ) references $tableClassRoom($classroomId) on delete cascade)
''');
          await db.execute('''
create table if not exists $tableRoster ( 
  $rosterDateId integer primary key, 
  $rosterClassId integer not null,
  $rosterCourseName varchar(15) ,
  $rosterSum integer ,
  $rosterAlready integer ,
  $rosterShould integer ,
  $rosterAbsence text,
  $rosterLeave text,
  foreign key($rosterClassId ) references $tableClassRoom($classroomId) on delete cascade)
''');
          await db.execute('''
create table if not exists $tableNote ( 
  $noteId integer primary key, 
  $noteTag integer not null,
  $noteDatetime varchar(12) ,
  $noteTitle varchar(20) ,
  $noteContent text)
''');
        });
  }

  Future<ClassRoom> insert(ClassRoom classroom) async {
    classroom.id = await db.insert(tableClassRoom, classroom.toMap());
    return classroom;
  }

  Future<ClassRoom> getClassRoom(int id) async {
    List<Map> maps = await db.query(tableClassRoom,
        columns: [classroomName, classroomSite, classroomSum],
        where: '$classroomId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ClassRoom.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ClassRoom>> getAll() async {
    List<Map> maps = await db.query(tableClassRoom,
        columns: [classroomId, classroomName, classroomSite,classroomSum],
        orderBy: classroomId,
    );
    if (maps.length > 0) {
      return maps.map((e){
        return ClassRoom.fromMap(e);
      }).toList();
    }
    return null;
  }

  Future<int> getMaxId() async{
    List<Map<String,dynamic>> data=await db.rawQuery("select max($classroomId)  from $tableClassRoom");
    return data[0]["max(id)"];
  }
  
  Future<int> delete(int id) async {
    return await db.delete(tableClassRoom, where: '$classroomId = ?', whereArgs: [id]);
  }

  Future<int> update(ClassRoom classroom) async {
    return await db.update(tableClassRoom, classroom.toMap(),
        where: '$classroomId = ?', whereArgs: [classroom.id]);
  }

  Future close() async => db.close();
}

class Student {
  int id;
  int classId;
  int seatId;
  String name;
  int sex ;     //0女 1 男
  int average;  //平均分
  bool notAbsence=true;
  bool notLeave=true;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      studentClassId:classId,
      studentSeatId: seatId,
      studentName : name,
      studentSex :sex,
      studentAverage : average
    };
    if (id != null) {
      map[studentId] = id;
    }
    return map;
  }

  Student({
    this.classId,
    this.seatId,
    this.name,
    this.sex,
    this.average
  });

  Student.fromMap(Map<String, dynamic> map) {
    id=map[studentId];
    classId= map[studentClassId];
    seatId= map[studentSeatId];
    name= map[studentName];
    sex= map[studentSex];
    average = map[studentAverage];
  }
}

class StudentProvider {
  Database db;

  void open(Database database){
    db=database;
  }

  Future<Student> insert(Student student) async {
    if(student.id!=null){
//      print("exist to update");
      update(student);
    }else{
//      print(student.toMap());
    student.id = await db.insert(tableStudent, student.toMap()).catchError((){
    });
    }
    return student;
  }

  Future<Student> getStudent(int classId,int seatId) async {
    List<Map> maps = await db.query(tableStudent,
        columns: [studentId, studentClassId, studentSeatId,studentName,studentSex,studentAverage],
        where: '$studentClassId = ? and $studentSeatId = ?',
        whereArgs: [classId,seatId]);
    if (maps.length > 0) {
      return Student.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Student>> getAll(int classId) async {
    List<Map> maps = await db.query(tableStudent,
        columns: [studentId, studentClassId, studentSeatId,studentName,studentSex,studentAverage],
        where: '$studentClassId = ?',
        whereArgs: [classId]);
    if (maps.length > 0) {
      return maps.map((e){
        return Student.fromMap(e);
      }).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableStudent, where: '$studentId = ?', whereArgs: [id]);
  }

  Future<int> update(Student student) async {
//    print(student.toMap());
    return await db.update(tableStudent, student.toMap(),
        where: '$studentId = ?', whereArgs: [student.id]);
  }

  Future close() async => db.close();
}

class Roster {
  int dateId;
  int classId;
  String courseName;
  int sum;
  int already;
  int should;
  String absence;
  String leave;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      rosterDateId :dateId,
      rosterClassId :classId,
      rosterCourseName:courseName,
      rosterSum:sum,
      rosterShould :should,
      rosterAlready :already,
      rosterAbsence:absence,
      rosterLeave:leave,
    };
    return map;
  }

  Roster({
    this.dateId,
    this.classId,
    this.courseName,
    this.sum,
    this.should,
    this.already,
    this.absence,
    this.leave
  });

  Roster.fromMap(Map<String, dynamic> map) {
    dateId = map[rosterDateId];
    classId = map[rosterClassId];
    courseName = map[rosterCourseName];
    sum = map[rosterSum];
    should = map[rosterShould];
    already = map[rosterAlready];
    absence = map[rosterAbsence];
    leave = map[rosterLeave];
  }
}

class RosterProvider {
  Database db;

  void open(Database database){
    db=database;
  }

  Future<Roster> insert(Roster roster) async {
    Roster temp;
    temp=await getRoster(roster.dateId);
    if(temp!=null)
    {
      print("Roster exist");
      return temp;
    }
    roster.dateId = await db.insert(tableRoster, roster.toMap());
    return roster;
  }

  Future<Roster> getRoster(int dateId) async {
    List<Map> maps = await db.query(tableRoster,
        columns: [rosterDateId, rosterClassId, rosterCourseName,rosterSum,rosterShould,rosterAlready,rosterAbsence,rosterLeave],
        where: '$rosterDateId = ?',
        whereArgs: [dateId]);
    if (maps.length > 0) {
      return Roster.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int dateId) async {
    return await db.delete(tableRoster, where: '$rosterDateId = ?', whereArgs: [dateId]);
  }

  Future<int> update(Roster roster) async {
    return await db.update(tableRoster, roster.toMap(),
        where: '$rosterDateId = ?', whereArgs: [roster.dateId]);
  }

  Future close() async => db.close();
}

class Note {
  int id;
  String datetime;
  int tag=1;
  String title='';
  String content='';

  Note({
    this.datetime,
    this.tag,
    this.title,
    this.content,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      noteDatetime :datetime,
      noteTag : tag,
      noteTitle:title,
      noteContent:content
    };
    if(id!=null)
      map[noteId]=id;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[noteId];
    datetime = map[noteDatetime];
    tag = map[noteTag];
    title = map[noteTitle];
    content=map[noteContent];
  }
}

class NoteProvider {
  Database db;

  void open(Database database){
    db=database;
  }

  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableNote, note.toMap());
    return note;
  }

  Future<Note> getRoster(int id) async {
    List<Map> maps = await db.query(tableNote,
        columns: [noteId, noteDatetime, noteTag,noteTitle,noteContent],
        where: '$noteId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Note>> getTen() async {
    List<Map> maps = await db.query(tableNote,
        columns: [noteId, noteDatetime, noteTag,noteTitle,noteContent],
        limit:10,
        orderBy: "$noteId desc",

    );
    if (maps.length > 0) {
      return maps.map((e){
        return Note.fromMap(e);
      }).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: '$noteId = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await db.update(tableNote, note.toMap(),
        where: '$noteId = ?', whereArgs: [note.id]);
  }

  Future close() async => db.close();
}