//计算对象
class Item {
  String name = '';
  double count = 0;
  String Image = '';
  int type = 0;
  String sign = '';
  Item ({required this.name,required this.count,required this.type,required this.sign});

  setImage(String image){
    this.Image = image;
  }
  double Count(double num){
    return num*count;
  }
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "count":count,
      "type":type,
      "sign":sign
    };
  }

  factory Item.fromMap(Map<String,dynamic> map){
    return Item(
      sign: map["sign"],
      type: map["type"],
        name: map["name"],
      count: map["count"]
    );
  }
}
//计算数据
class CountNode{
  //产生碳足迹：
  double count = 0;
  //碳足迹类型
  int type  = 0;
  //计算时间
  String date = '';

  CountNode({required this.count,required this.type,required this.date});

  Map<String,dynamic> toMap(){
    return{
      "count":count,
      "type":type,
      "date":date
    };
  }
  factory CountNode.fromMap(Map<String,dynamic> map){
    return CountNode(
        type: map["type"],
        date: map["date"],
        count: map["count"]
    );
  }
}