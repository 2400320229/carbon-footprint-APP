class Item {
  String name = '';
  double count = 0;
  String Image = '';
  int type = 0;
  Item ({required this.name,required this.count,required this.type});

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
      "type":type
    };
  }

  factory Item.fromMap(Map<String,dynamic> map){
    return Item(
      type: map["type"],
        name: map["name"],
      count: map["count"]
    );
  }
}