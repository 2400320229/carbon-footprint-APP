class Item {
  String name = '';
  double count = 0;
  String Image = '';

  Item (String name,double count){
    this.name = name;
    this.count = count;
  }
  setImage(String image){
    this.Image = image;
  }
  double Count(double num){
    return num*count;
  }
}