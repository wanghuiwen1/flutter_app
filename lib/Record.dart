class Record {

  String date;

  String money;

  String type;

  toMap(){
    Map<String, dynamic> map = {"date":this.date,"money":this.money,"type":this.type};
    return map;
  }

}