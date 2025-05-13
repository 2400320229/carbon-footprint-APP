import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Pages/main.dart';
import 'package:get/get.dart';
import 'package:flutter_try/Pages/land.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../language/language.dart';



List<Item> item_yi_arr = [];
List<Item> item_shi_arr = [];
List<Item> item_zhu_arr = [];
List<Item> item_xing_arr = [];
List<List<Item>> arr_type = List_o_data;
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
    logger.d(all_ItemList);
    //init();
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
        backgroundColor: Color(0xFF728873),
        appBar: AppBar(
          bottom:PreferredSize(
            preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
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


            /*actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              Select_count = 0;
            });
          }, child: Text("衣")),
          ElevatedButton(onPressed: (){
            setState(() {
              Select_count = 1;
            });
          }, child: Text("食")),
          ElevatedButton(onPressed: (){
            setState(() {
              Select_count = 2;
            });
          }, child: Text("住")),
          ElevatedButton(onPressed: (){
            setState(() {
              Select_count = 3;
            });
          }, child: Text("行"))

        ],*/
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


                /*if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
            SizedBox(
              child: Text(_recognizedText),
              width: 100,
              height: 100,
            ),
            ElevatedButton(onPressed: ()=>{
              _pickImage()
            }, child: Text("选择照片")),
            ElevatedButton(onPressed: (){
              *//*Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const Land())
            );*//*
              //Get.toNamed("/land",arguments: {"value":"你点击了登录"});
              sendCode("2051874395@qq.com");
            }, child: Text('登录')),
            ElevatedButton(onPressed: (){
              var locale = Locale("zh","CN");
              Get.updateLocale(locale);
            }, child: Text('CN')),
            ElevatedButton(onPressed: (){
              var locale = Locale("en","US");
              Get.snackbar("en", "US",backgroundColor: Colors.green);
              Get.updateLocale(locale);
            }, child: Text('US'))*/
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
  Future<void> sendCode(String email) async {
    /*final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/send-code'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );*/
    var address = await getLocalIPAddresses();
    var address1 = address[0];
    final response = await http.get(Uri.parse("http://10.33.120.2:8080/send-code?email=$email"));
    print(response.body);
  }
  Future<List<String>> getLocalIPAddresses() async {
    List<String> ipAddresses = [];
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type.name == 'IPv4') {
            ipAddresses.add(addr.address);
          }
        }
      }
    } catch (e) {
      print('获取 IP 地址时出错: $e');
    }
    return ipAddresses;
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
    init();
  }
  init()async{

    List<List<Item>> arr = List_o_data;
    Timer(Duration(milliseconds:2000), () {
      logger.d("item_yi_arr"+all_ItemList.toString());
      if(all_ItemList.isNotEmpty){
        item_yi_arr = all_ItemList["1"]!;
        if(item_yi_arr[item_yi_arr.length-1].name != "add"){
          item_yi_arr.add(new Item(name: "add", count: 0, type: 0,sign: ""));
        }

        item_shi_arr = all_ItemList["2"]!;
        if(item_shi_arr[item_shi_arr.length-1].name != "add"){
          item_shi_arr.add(new Item(name: "add", count: 0, type: 0,sign: ""));
        }

        item_zhu_arr = all_ItemList["3"]!;
        if(item_zhu_arr[item_zhu_arr.length-1].name != "add"){
          item_zhu_arr.add(new Item(name: "add", count: 0, type: 0,sign: ""));
        }

        item_xing_arr = all_ItemList["4"]!;
        if(item_xing_arr[item_xing_arr.length-1].name != "add"){
          item_xing_arr.add(new Item(name: "add", count: 0, type: 0,sign: ""));
        }

        logger.d(item_yi_arr.toString()+"is_yi");
      }
      arr[0] = item_yi_arr;
      arr[1] = item_shi_arr;
      arr[2] = item_zhu_arr;
      arr[3] = item_xing_arr;
      setState(() {
        arr_type = arr;
        logger.d(arr_type);
      });
    });


  }
  @override
  Widget build(context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
          crossAxisSpacing: 10, // 水平间距
          mainAxisSpacing: 10,  // 垂直间距
          childAspectRatio: 1.5 // 子项宽高比

    ),
    itemCount:arr_type[Select_count].length,
    itemBuilder: (context,index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:arr_type[Select_count][index].type==0?Color(0xFF8C8C8C): Colors.white,
        ),
        child: Column(
          children:arr_type[Select_count][index].name=="add"?[
            Text(arr_type[Select_count][index].name.tr,style: TextStyle(fontSize: 10),),
          ]: [
            Image.asset("images/"+arr_type[Select_count][index].name+".png",width: double.infinity,height: 35,fit: BoxFit.cover,),
            Text(arr_type[Select_count][index].name.tr,style: TextStyle(fontSize: 10),),
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
      add_new_item = await new Item(name: add_name.text, count: double.parse(add_count.text), type: Select_count+1,sign: add_sign.text);
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
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10))
            ),
            child:Column(
              children: [
                Text(select_item.name),
                TextField(controller: add_name,
                decoration: InputDecoration(
                  label: Text("名字"),
                  border: OutlineInputBorder()
                ),),
                TextField(controller: add_count,
                  decoration: InputDecoration(
                      label: Text("数值"),
                      border: OutlineInputBorder()
                  ),),
                TextField(controller: add_sign,
                  decoration: InputDecoration(
                      label: Text("单位"),
                      border: OutlineInputBorder()
                  ),),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      if(add_name.text.isNotEmpty&&add_count.text.isNotEmpty&&add_sign.text.isNotEmpty){
                        add_item();
                        widget.On_show();

                      }else{
                        Get.snackbar("请输入数据", "");
                      }

                    }, child: Text("添加")),
                    ElevatedButton(onPressed: (){
                      widget.On_show();
                      }, child: Text("保存")),
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

                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      double a = double.parse(input_text.text);
                      double b = select_item.count;
                      setState(() {
                        result = (a*b).toString();
                        display_result = "结果为："+ (double.parse(result).toStringAsFixed(2)).toString();
                      });
                      logger.d(result);
                    }, child: Text("计算")),
                    ElevatedButton(onPressed: (){
                      add_conut_node();
                    }, child: Text("保存")),
                  ],
                )
              ],
            ) ,
          ),
        )
      ],
    );
  }
}
