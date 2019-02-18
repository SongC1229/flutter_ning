roster{     //花名册
    dateId varchar(9) ,//时间+节次  201902109
    classId int ,    //班级
    courseName varchar(20), //课程名
    sum     int ,    //总数
    should   int,    //应到
    already int     //已到
    absence text    //缺勤名单
    leave   text    //请假名单
}

classroom{
    id int  primary key autoincrement , //班级id  主键自增
    name varchar(15) ,//班级名称 
    site varchar(15) ,//班级位置
    sum int ,//总人数
}

student{
    id int primary key autoincrement ,  //自增主键
    seatid varchar(15) ,              //学号
    name varchar(10) ,                   //姓名cc
    sex int ,                            //性别
    classId int 
    foreign key(classId) references classroom(id) on delete cascade
}