import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Record.dart';
import 'add.dart';

void main() {
//  debugPaintSizeEnabled=true;
  runApp(new MyApp());
}

class One extends StatefulWidget  {
  @override
  State<StatefulWidget> createState()=>new OneStat() ;
}

class OneStat extends State<One> {
  Database _database;
  var _day;
  var _month;
  Future<List<Map<String, dynamic>>> _list() async {
    List<Map<String, dynamic>> result = new List(2);
    var dc = await getApplicationDocumentsDirectory();
    String path = dc.path + "demo.db";
    // open the database
    _database = await openDatabase(path, version: 1);
       var day= await _database.rawQuery("select sum(money) from record where date like ?",[DateTime.now().toString().substring(0,10)+"%"]);
       var  money= await _database.rawQuery("select sum(money) from record where date like ?",[DateTime.now().toString().substring(0,7)+"%"]);
         result[0]={"day":day[0]["sum(money)"]};
         result[1]={"month":money[0]["sum(money)"]};
       return result;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.all(20.1),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Text("今日支出"), Text(_day==null?"0":_day.toString())]),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Text("本月支出"), Text(_month==null?"0":_month.toString())]),
            ]));
  }

  @override
  void initState() {
    super.initState();
    _list().then((list){
      setState(() {
        _day=list[0]["day"];
        _month=list[1]["month"];
      });
    });

  }


}
class FullList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FullStat();

}

class FullStat extends State<FullList> {
  Database _database;
  List<Map<String, dynamic>> items = new List();
  Future<List<Map<String, dynamic>>> _list() async{
    var dc=await getApplicationDocumentsDirectory();
    String path=dc.path+"demo.db";
    // open the database
     _database = await openDatabase(path, version: 1);
    return await _database.query("record");
//    await database.close();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: One(),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index){
                  return Container(
                    padding:const EdgeInsets.fromLTRB(10.1, 5.0, 10.1, 5.0),
                    margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
                    alignment: Alignment.centerRight,
                    decoration: new BoxDecoration(
                      border: new Border.all(width: 1.0, color: Colors.black12),
                        borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
                        color: Colors.grey,
                  ),
                    child: Row(children:<Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(items[index]["type"].toString(),textAlign: TextAlign.center,)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(items[index]["money"].toString()+" 元",textAlign: TextAlign.center)),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(items[index]["date"]!=null?items[index]["date"].substring(5,19):"",textAlign: TextAlign.center)),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
                childCount: items.length)
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _list().then((res){
      setState(() {
        res.forEach((f){
          items.add(f);
        });
      });
//      _database.close();
    });
  }
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Scaffold是Material中主要的布局组件.
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('小账本'),
        automaticallyImplyLeading:false ,
      ),
      //body占屏幕的大部分
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 11.1),
          child: FullList()),
      floatingActionButton: new FloatingActionButton(
          tooltip: 'Add', // used by assistive technologies
          child: new Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context,'/add');
          }),
    );
  }
}

class MyApp extends StatelessWidget {
  _createDb(name) async {
    var dc = await getApplicationDocumentsDirectory();
    String path = dc.path + name;
    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
          db.execute(
              "create table record (id long,money varchar(255),date varchar(255),type varchar(255))");
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _createDb("demo.db");
    return new MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: new TutorialHome(),
      routes: <String, WidgetBuilder> {
        '/add': (BuildContext context) => new Add(),
        '/home' : (BuildContext context) => new TutorialHome(),
      },
    );
  }
}