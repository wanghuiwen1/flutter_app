
import 'dart:io';
class Record {

  String date;

  String money;

  String type;

  String image;

  toMap(){
    Map<String, dynamic> map = {"date":this.date,"money":this.money,"type":this.type,"image":this.image};
    return map;
  }

}