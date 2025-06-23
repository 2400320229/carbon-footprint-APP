import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Pages/main.dart';
import 'package:get/get.dart';
import 'package:flutter_try/Pages/land.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/String.dart';

List<Item> item_yi_arr = [];
List<Item> item_shi_arr = [];
List<Item> item_zhu_arr = [];
List<Item> item_xing_arr = [];
List<List<Item>> arr_type = [];
int Select_count = 0;
Item select_item = new Item(name:'', count:0,type: 0,sign: "");
Item add_new_item = new Item(name:'', count:0,type: 0,sign: '');
bool is_show_count = false;

class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}
class _Home_pageState extends State<Home_page> {

  final GlobalKey<_My_GridviewState> childKey = GlobalKey();
  String _recognizedText = '';
  File? _selectedImage;
  int is_add_change = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      arr_type = List_o_data;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  TextEditingController massage = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x4FF3F3F3),
        appBar: AppBar(
          title: Text("carbon footprint calculator".tr),
          bottom:PreferredSize(
            preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("images/icons/cloth.png")),
                  label: '衣',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_food_beverage),
                  label: '食',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.house),
                  label: '住',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_bike),
                  label: '行',
                ),
              ],
              currentIndex: Select_count,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.black12,
              onTap: (index){
                setState(() {
                  Select_count = index;
                });
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child:Column(
                  children: [
                    Expanded(child: My_Gridview(Show: (){
                      setState(() {
                        is_show_count = true;
                      });
                    },key: childKey,)),
                  ]
              ),
            ),
            if(is_show_count)
              Conpute_page(
                On_show: (){
                  setState(() {
                    is_show_count = false;
                  });

                },
                is_add: (){
                  setState(() {
                    arr_type[Select_count].insert(arr_type[Select_count].length-1,add_new_item);
                  });
                },
              )
          ],
        )
    );
  }


}
class My_Gridview extends StatefulWidget {
  final VoidCallback Show;

  My_Gridview({super.key,required this.Show});

  @override
  State<My_Gridview> createState() => _My_GridviewState();
}

class _My_GridviewState extends State<My_Gridview> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arr_type = List_o_data;
    logger.d("${arr_type}");
    init();
  }
  Future<void> init() async {
    logger.d("init");

    var list  = await nodedb.get_allItem();
    final jsonData = {
      '1': list["1"]!.map((e) => e.toJson()).toList(),
      '2': list["2"]!.map((e) => e.toJson()).toList(),
      '3': list["3"]!.map((e) => e.toJson()).toList(),
      '4': list["4"]!.map((e) => e.toJson()).toList(),
    };

// 调用compute
    final jsonResult = await compute(processData, jsonData);

// 结果转换
    final result = jsonResult.map((list) =>
        list.map((e) => Item.fromJson(e)).toList()
    ).toList();

    //final result = await compute(processData, all_ItemList);
    setState(() {
      arr_type = result;
      logger.d("数据处理完成: ${arr_type.length}");
      logger.d("数据处理完成: ${arr_type}" +"${result}");
    });
  }

  static Future<List<List<Map<String, dynamic>>>> processData(Map<String, List<Map<String, dynamic>>> jsonData) async {
    // 转换输入数据
    final allItemList = jsonData.map((key, value) =>
        MapEntry(key, value.map((e) => Item.fromJson(e)).toList())
    );
    logger.d("compute111"+"${allItemList}");
    // 调用实际处理逻辑
    final result = await _processItemData(allItemList);
    logger.d("compute222"+"${result}");
    // 转换输出数据
    return result.map((list) =>
        list.map((item) => item.toJson()).toList()
    ).toList();
  }

// 实际处理逻辑，保持原有代码不变
  static Future<List<List<Item>>> _processItemData(Map<String, List<Item>> allItemList) async {
    logger.d("开始处理数据，allItemList: ${allItemList.length}个条目");

    List<Item> item_yi_arr = allItemList["1"] ?? [];
    List<Item> item_shi_arr = allItemList["2"] ?? [];
    List<Item> item_zhu_arr = allItemList["3"] ?? [];
    List<Item> item_xing_arr = allItemList["4"] ?? [];

    if (item_yi_arr.isNotEmpty && item_yi_arr.last.name != "add") {
      item_yi_arr.add(Item(name: "add".tr, count: 0, type: 0, sign: ""));
    }

    if (item_shi_arr.isNotEmpty && item_shi_arr.last.name != "add") {
      item_shi_arr.add(Item(name: "add".tr, count: 0, type: 0, sign: ""));
    }

    if (item_zhu_arr.isNotEmpty && item_zhu_arr.last.name != "add") {
      item_zhu_arr.add(Item(name: "add".tr, count: 0, type: 0, sign: ""));
    }

    if (item_xing_arr.isNotEmpty && item_xing_arr.last.name != "add") {
      item_xing_arr.add(Item(name: "add".tr, count: 0, type: 0, sign: ""));
    }

    logger.d("数据处理完成");

    return [item_yi_arr, item_shi_arr, item_zhu_arr, item_xing_arr];
  }

  @override
  Widget build(context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
          crossAxisSpacing: 10, // 水平间距
          mainAxisSpacing: 10,  // 垂直间距
          childAspectRatio: 1.33 // 子项宽高比

    ),
    itemCount:arr_type[Select_count].length,
    itemBuilder: (context,index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:arr_type[Select_count][index].type==0?Color(0x918C8C8C): Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:arr_type[Select_count][index].name=="add"?[
            Icon(Icons.add,size:40,color: Colors.white,),
          ]: [
            Container(
              width:50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // 所有角都是圆角
                ),
              child:arr_type[Select_count][index].name.contains("+")?Text(""):
              Image.asset("images/"+arr_type[Select_count][index].name+".png",width: 50,height: 50,fit:BoxFit.cover,)
            ),
            Expanded(
              child: Text(arr_type[Select_count][index].name.tr,style: TextStyle(fontSize: 10),),
            ),

          ],
        )
      ),
      onTap: (){
       widget.Show();
       select_item = arr_type[Select_count][index];
      },
    );

    }
    );
  }
}

class Conpute_page extends StatefulWidget {
  final VoidCallback On_show;
  final VoidCallback is_add;
  const Conpute_page({super.key,required this.On_show,required this.is_add});

  @override
  State<Conpute_page> createState() => _Conpute_pageState();
}
class _Conpute_pageState extends State<Conpute_page> {
  var input_text = TextEditingController();
  var add_name = TextEditingController();
  var add_count = TextEditingController();
  var add_sign = TextEditingController();
  var add_type = select_item.type;
  String result = '';
  String display_result = '';
  add_item()async{
    if(add_count.text.isNotEmpty&&add_name.text.isNotEmpty){
      add_new_item = await new Item(name: "+"+add_name.text, count: double.parse(add_count.text), type: Select_count+1,sign: add_sign.text);
      logger.d(add_new_item.name+add_new_item.type.toString());
      logger.d("double +++"+double.parse(add_count.text).toString());
      await nodedb.insert_Item(add_new_item);
    }

    widget.is_add();
  }
  add_conut_node()async{
    DateTime now = DateTime.now();
    var a = new CountNode(count: double.parse(result), type: Select_count+1, date: now.toString());
    await nodedb.insert_CountNode(a);
    widget.On_show;
    sava_data();
  }
  @override
  Widget build(BuildContext context) {
    return select_item.type == 0?
    Stack(
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
          onTap: (){widget.On_show();},
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10))
            ),
            child:Column(
              children: [
                Text(select_item.name),
                SizedBox(height: 5,),
                Container(
                  height: 50,
                  width: 300,
                  child: TextField(controller: add_name,
                    decoration: InputDecoration(
                        label: Text("名字"),
                        border: OutlineInputBorder()
                    ),),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 50,
                  width: 300,
                  child: TextField(controller: add_count,
                    decoration: InputDecoration(
                        label: Text("数值"),
                        border: OutlineInputBorder()
                    ),),
                ),
                SizedBox(height: 5,),
                Container(
                    height: 50,
                    width: 300,
                    child: TextField(controller: add_sign,
                      decoration: InputDecoration(
                          label: Text("单位"),
                          border: OutlineInputBorder()
                      ),)
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){
                      if(add_name.text.isNotEmpty&&add_count.text.isNotEmpty&&add_sign.text.isNotEmpty){
                        add_item();
                        widget.On_show();
                      }else{
                        Get.snackbar("请输入数据", "",backgroundColor: Colors.green);
                      }
                    }, child: Text("add".tr),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                      side: BorderSide(
                        color: Color(0xFF728873),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF728873),
                    ),),
                    ElevatedButton(onPressed: (){
                      widget.On_show();
                      }, child: Text("back".tr),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 50),
                        side: BorderSide(
                          color: Color(0xFF728873),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF728873),
                      ),),
                  ],
                )
              ],
            ) ,
          ),
        )
      ],
    )
    :Stack(
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),
          onTap: (){widget.On_show();},
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10))
            ),
            child:Column(
              children: [
                SizedBox(height: 10),
                Text(select_item.name.tr,style: TextStyle(fontSize: 30),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: TextField(controller: input_text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder()
                        ),),
                      width:200,
                      height: 50,
                    ),
                    Text(select_item.sign,style: TextStyle(fontSize: 30),)

                  ],
                ),
                Row(
                  children: [Text(display_result,style: TextStyle(fontSize: 30,),maxLines: 1,)],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){
                      double a = double.parse(input_text.text);
                      double b = select_item.count;
                      setState(() {
                        result = (a*b).toString();
                        display_result = "result is: ".tr+ (double.parse(result).toStringAsFixed(2)).toString()+"CO₂e";
                      });
                      logger.d(result);
                    }, child: Text("calculate".tr),
                      style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 50),
                      side: BorderSide(
                        color: Color(0xFF728873),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF728873),
                    ),
                    ),
                    ElevatedButton(onPressed: (){
                      add_conut_node();
                    }, child: Text("sava".tr),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 50),
                        side: BorderSide(
                          color: Color(0xFF728873),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF728873),
                      ),),
                  ],
                )
              ],
            ) ,
          ),
        )
      ],
    );
  }
  sava_data()async{
    DateTime now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    var ip = await prefs.getString("ip");
    var email = await prefs.getString("user_email");
    logger.d(ip.toString()+email.toString());
    if(ip != ''&& email != ''){
      var newData = "|"+result+"?"+(Select_count+1).toString()+"?"+now.toString();
      logger.d(newData);
      await http.post(
        Uri.parse("http://$ip:8000/update_data"),
        body:jsonEncode({"email":email,"data":newData.toString()}),
        headers: {'Content-Type': 'application/json'}
      );
    }
    else{
      Get.snackbar("数据不完整", "请登录或输入ip地址");
    }

  }
  setUserData()async{

  }
}
