import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/main.dart';
import 'package:get/get.dart';
import 'package:flutter_try/land.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

List<Item> item_yi_arr = [];
List<Item> item_shi_arr = [];
List<Item> item_zhu_arr = [];
List<Item> item_xing_arr = [];
List<List<Item>> arr_type = [[],[],[],[]];
Map<String,List<Item>> all_ItemList = {};
int Select_count = 0;
Item select_item = new Item(name:'', count:0,type: 0);
Item add_new_item = new Item(name:'', count:0,type: 0);
bool is_show_count = false;


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
    init();
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
        actions: [
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

        ],
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
  init()async{
    all_ItemList = await nodedb.get_allItem();
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

/*class CounterProvider extends ChangeNotifier {
  int counter = 0;

  void incrementCounter() {
    arr_type[select_item.type-1].add(add_new_item);
    counter++;
    notifyListeners();
  }
}*/

class _My_GridviewState extends State<My_Gridview> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init()async{

    List<List<Item>> arr = [[],[],[],[]];
    Timer(Duration(seconds: 1), () {
      logger.d("item_yi_arr"+all_ItemList.toString());
      if(all_ItemList.isNotEmpty){
        item_yi_arr = all_ItemList["1"]!;
        item_yi_arr.add(new Item(name: "add", count: 0, type: 0));

        item_shi_arr = all_ItemList["2"]!;
        item_shi_arr.add(new Item(name: "add", count: 0, type: 0));

        item_zhu_arr = all_ItemList["3"]!;
        item_zhu_arr.add(new Item(name: "add", count: 0, type: 0));

        item_xing_arr = all_ItemList["4"]!;
        item_xing_arr.add(new Item(name: "add", count: 0, type: 0));
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
      crossAxisCount: 2,
          crossAxisSpacing: 10, // 水平间距
          mainAxisSpacing: 10,  // 垂直间距
          childAspectRatio: 1.0 // 子项宽高比

    ),
    itemCount:arr_type[Select_count].length,
    itemBuilder: (context,index){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:arr_type[Select_count][index].type==0?Color(0xFF8C8C8C): Colors.white,
        ),
        child: Text(arr_type[Select_count][index].name),
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
  var add_type = select_item.type;
  String result = '';
  add_item()async{
    if(add_count.text.isNotEmpty&&add_name.text.isNotEmpty){
      add_new_item = await new Item(name: add_name.text, count: double.parse(add_count.text), type: Select_count+1);
      logger.d(add_new_item.name+add_new_item.type.toString());
      logger.d("double +++"+double.parse(add_count.text).toString());
      await nodedb.insert_Item(add_new_item);
    }

    widget.is_add();
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
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      add_item();
                      widget.On_show();
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
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight: Radius.circular(10))
            ),
            child:Column(
              children: [
                Text(select_item.name),
                TextField(controller: input_text,),
                Text(result),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      double a = double.parse(input_text.text);
                      double b = select_item.count;
                      setState(() {
                        result = (a*b).toString();
                      });
                      logger.d(result);
                    }, child: Text("计算")),
                    ElevatedButton(onPressed: (){}, child: Text("保存")),
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
