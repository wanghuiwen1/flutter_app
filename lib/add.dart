import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'Record.dart';
import 'package:card_settings/card_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Add extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new AddStat();
}

class AddStat extends State<Add> {
  Record record= new Record();
  TimeOfDay time= TimeOfDay.now();
  DateTime date=DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Database _database;
  _save() async{
    var dc=await getApplicationDocumentsDirectory();
    String path=dc.path+"demo.db";
    // open the database
    _database = await openDatabase(path, version: 1);
    await _database.insert("record",record.toMap());
    await _database.close();
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget Add() => new Container();

    Widget Finsh() => new Row(
      children: <Widget>[
        Expanded(child:new RaisedButton(child: new Text("添加"),
          onPressed: (){
            _save();

          },))
      ],
    );
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        record.image = image.path;
      });
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('添加'),

        ),
        body:Container(
            padding: EdgeInsets.all(5.1),
            child: Form(
                key: _formKey,
                child: CardSettings(
                    children: <Widget>[
                      CardSettingsText(
                        label: '金额',
                        keyboardType: TextInputType.number,
                        initialValue: "0",
                        onSaved: (value){
                          record.money=value;
                        },
                      ),
                      CardSettingsListPicker(
                        label: '类型',
                        options: ["消费","餐饮","娱乐"],
                        initialValue: "消费",
                        onSaved: (value){
                          record.type=value;
                        },

                      ),
                      CardSettingsTimePicker(
                        label: "时间",
                        initialValue: TimeOfDay.now(),
                        onSaved: (value){
                            setState(() {
                              time=value;
                            });
                        },
                      ),
                      CardSettingsDatePicker(
                        label: "日期",
                        initialValue: DateTime.now(),
                        onSaved: (value){
                          setState(() {
                            date=value;
                          });

                        },
                      ),
                      CardSettingsField(
                          label: "图片",
                          content: Container(
                            child: record.image==null?RaisedButton(onPressed: getImage,):new Image.file(File(record.image)),
                          )
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardSettingsButton(
                          label: "添加",
                          onPressed: (){
                            _formKey.currentState.save();
                            record.date=date.toString()+" "+time.toString();
                            _save();
                          },
                        ),
                      )

                    ]
                )
            )
        )
    );
  }
}