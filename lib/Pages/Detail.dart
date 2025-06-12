import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_try/Pages/land.dart';
import 'package:flutter_try/model/String.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Base/Item.dart';
import 'main.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final args = Get.arguments;
  Widget page = Column();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.d(args);
    if(args == '1'){
      setState(() {
        page = dataList();
      });
    }else if(args == "2"){
      setState(() {
        page = UpdateLanguage();
      });
    }else if(args == "3"){
      setState(() {
        page = updateIp();
      });
    }else if(args == "4"){
      setState(() {
        page = TextList();
      });
    } else if(args == "5"){
      setState(() {
        page = UserList();
      });
    } else if(args == "6"){
      setState(() {
        page = UpdatePassword();
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(child: page),
        ],
      )
    );
  }
}
class dataList extends StatefulWidget {

  dataList({super.key});

  @override
  State<dataList> createState() => _dataListState();
}

class _dataListState extends State<dataList> {
  List<CountNode> NodeList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.d("is init dataList");
    init();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SizedBox(width: 10,),IconButton(onPressed:(){Get.back();}, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
        Container(width: double.infinity,height: 2,color: Color(0xFF728873)),
        Expanded(child:ListView.builder(itemCount: NodeList.length,
            itemBuilder: (BuildContext context,index){
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("产生:"+NodeList[index].count.toString()),
                    Text("类型:"+NodeList[index].type.toString()),
                    Text("时间:"+NodeList[index].date.split(' ')[0]),
                  ],
                ),
              );
            }) )
      ],
    );
  }
  init()async{
    var a = await nodedb.getAllCountNode();
    logger.d("count data is"+a.toString());
    setState(() {
      NodeList = a;
    });
  }
}


class UpdateLanguage extends StatefulWidget {

  UpdateLanguage({super.key});

  @override
  State<UpdateLanguage> createState() => _UpdateLanguageState();
}

class _UpdateLanguageState extends State<UpdateLanguage> {

  String language = Get.locale.toString();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.d(language);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SizedBox(width: 10,),IconButton(onPressed: (){Get.back();}, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
        Container(width: double.infinity,height: 2,color: Color(0xFF728873)),
        CheckboxListTile(
          title: Text('中文'),
          value: language == "zh_CN",
          onChanged: (bool? newValue) {
            setState(() {
              Get.updateLocale(Locale("zh_CN"));
              language = "zh_CN";
            });
          },
          secondary: Icon(Icons.article), // 可选图标
        ),
        CheckboxListTile(
          title: Text('English'),
          value: language == "en_US",
          onChanged: (bool? newValue) {
            setState(() {
              Get.updateLocale(Locale('en_US'));
              language = "en_US";
            });
          },
          secondary: Image.asset("images/221.png"), // 可选图标
        ),
      ],
    );
  }
}

class TextList extends StatelessWidget {
  const TextList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Text("——、软件背景"),
            Text(in_background),
            Text("二、软件用途"),
            Text(in_use)
          ],
        ),

      ],
    );
  }
}
class updateIp extends StatefulWidget {

  updateIp({super.key});
  @override
  State<updateIp> createState() => _updateIpState();
}

class _updateIpState extends State<updateIp> {
  TextEditingController ip_address = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SizedBox(width: 10,),IconButton(onPressed:(){Get.back();}, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
        Container(width: double.infinity,height: 2,color: Color(0xFF728873)),
        TextField(controller: ip_address,),
        ElevatedButton(onPressed: save, child: Text("保存")),
      ],
    );
  }
  save()async{
    final p = await SharedPreferences.getInstance();
    p.setString("ip", ip_address.text);
    logger.d(ip_address.text);
  }
}


class UserOnList{

  String name;
  String data = '';
  UserOnList({required this.name});
  setData(Map<String,dynamic> data){
    //data
  }
}
class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool is_land = false;
  List<Map<String,String>>userList = [];
  List<Widget>UserCardList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.d("UserList");
    init();
  }
  init()async{
    final p = await SharedPreferences.getInstance();
    var aa = await p.getBool("is_land") ?? false; // 添加默认值
    setState(() {
      is_land = aa;
    });
    var ip = await p.getString("ip") ?? "localhost"; // 添加默认值
    var email = await p.getString("user_email") ?? ""; // 添加默认值

    // 检查必要参数
    if (ip.isEmpty || email.isEmpty) {
      Get.snackbar("错误", "缺少必要参数: IP或邮箱为空");
      logger.e("缺少必要参数: IP或邮箱为空");
      return;
    }
    final response = await http.get(
      Uri.parse('http://$ip:8000/get_user'),
      headers: {'Content-Type': 'application/json'},
    );
    logger.d(response.body.toString());
    final jsonMap = json.decode(response.body) as Map<String, dynamic>;
    final message = jsonMap['message'] as List<dynamic>;
    logger.d(message[0]);
    logger.d(message[0][5]);
    List<Map<String,String>> newList = [];
    for(var a in message){
      newList.add({
        "username":a[0].toString(),
        "data":a[5].toString(),
        "image":a[4].toString()
      });
    }
    setState(() {
      logger.d(newList);
      userList = newList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: !is_land ?
      [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("请登录",style: TextStyle(fontSize: 50),),
            ElevatedButton(onPressed: (){
              Get.toNamed("/land");
            }, child: Text("去登录"))
          ],
        )
      ]:[
        Row(
          children: [
            SizedBox(width: 10,),
            IconButton(
                onPressed: (){Get.back();},
                icon: ImageIcon(AssetImage("images/icons/back.png"))
            )],
        ),
        Expanded(
            child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context,index){
          return ListTile(
            title:Container(
              height: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border:Border.all(
                  width: 2,
                  color: Color(0xFF38783F)
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child:Row(
                children: [
                  Text((index+1).toString(),style: TextStyle(fontSize:30),),
                  UserCard(
                      data: userList[index]["data"].toString(),
                      image: userList[index]["image"].toString(),
                      username: userList[index]["username"].toString()
                  ),
                ],
              )
            ),
          );
        }))
      ],
    );
  }
}


class UserCard extends StatefulWidget {
  String? username;
  String? data;
  String? image;
  UserCard({super.key,required this.data,required this.image,required this.username});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  String sumData = '';
  @override
  void initState() {
    // TODO: implement initState
    double sum = 0;
    for(var i in widget.data.toString().split("|")){
      if(i.isNotEmpty){
        sum += double.parse(i.split("?")[0]);
      }
    }
    setState(() {
      sumData = sum.toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child:Image.asset("images/221.png"),
          ),
          Column(
            children: [
              Text(widget.username.toString(),style: TextStyle(fontSize: 30),),
              Text("总产生量："+sumData)
            ],
          )
        ],
      ),
    );
  }
}

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String ip = '';
  bool is_land = false;
  TextEditingController old_password = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController new_password = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init()async{
    final p = await SharedPreferences.getInstance();
    var aa = await p.getBool("is_land") ?? false; // 添加默认值
    setState(() {
      is_land = aa;
    });
    ip = await p.getString("ip") ?? "localhost"; // 添加默认值
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children:!is_land ? [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("请登录",style: TextStyle(fontSize: 50),),
            ElevatedButton(onPressed: (){
              Get.toNamed("/land");
            }, child: Text("去登录"))
          ],
        )
      ]:[
        Row(
          children: [
            SizedBox(width: 10,),
            IconButton(
                onPressed: (){Get.back();},
                icon: ImageIcon(AssetImage("images/icons/back.png"))
            )],
        ),
        Text("更改密码",style: TextStyle(
            fontSize: 30
        ),),
        Container(
          child:Column(
            children: [
              Container(
                height: 50,
                width: 300,
                child:TextField(
                  controller: email,
                  decoration: InputDecoration(
                    label: Text("邮箱"),
                    border: OutlineInputBorder()
                ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 300,
                child: TextField(
                  controller: old_password,
                  decoration: InputDecoration(
                      label: Text("原密码"),
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 300,
                child:TextField(
                  controller: new_password,
                  decoration: InputDecoration(
                      label: Text("新密码"),
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: ElevatedButton(onPressed: (){
                  if(email.text.isNotEmpty && old_password.text.isNotEmpty && new_password.text.isNotEmpty){
                    update_password();
                  }
                }, child: Text("更改密码"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, double.infinity),
                  side: BorderSide(
                    color: Color(0xFF728873),
                    width: 1.5
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF728873),
                ),),
              )
            ],
          ),
        )
      ],
    );
  }
  update_password()async{
    final response = await http.post(
      Uri.parse('http://$ip:8000/update_password'),
      body: jsonEncode({"email":email.text,"old_password":old_password.text,"new_password":new_password.text}),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      Get.snackbar("更改成功", '更改成功');
      Get.back();
    }else if(response.statusCode == 401){
      Get.snackbar("更改失败", '邮箱未注册');
    }
    else if(response.statusCode == 402){
      Get.snackbar("更改失败", '密码错误');
    }else{
      Get.snackbar("错误","数据库错误");
    }
  }
}
