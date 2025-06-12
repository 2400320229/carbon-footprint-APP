import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Pages/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/land.dart';

class User_page extends StatefulWidget {
  const User_page({super.key});

  @override
  State<User_page> createState() => _User_pageState();
}

class _User_pageState extends State<User_page> {
  bool is_show_data = false;
  bool is_show_language = false;
  bool is_show_IP = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10,right: 0),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    UserLanding(),
                    Expanded(child: ListView(
                      children: [
                        ListTile(
                          title: Column(
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "5");
                                }, child:Row(children: [Text("排行榜"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "1");
                                }, child: Row(children: [Text("数据"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "2");
                                }, child:Row(children: [Text("语言"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "6");
                                }, child:Row(children: [Text("更改密码"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "4");
                                }, child:Row(children: [Text("关于"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Get.toNamed("/DetailPage",arguments: "3");
                                }, child:Row(children: [Text("IP地址"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  _showInputDialog(context);
                                }, child:Row(children: [Text("退出登录"),ImageIcon(AssetImage("images/icons/goto.png"))],),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 60), // 设置固定尺寸
                                    side: BorderSide(
                                      color: Color(0xFF728873),      // 边框颜色
                                      width: 1.5,             // 边框宽度
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 圆角
                                    ),
                                    elevation: 4,             // 阴影高度
                                    backgroundColor: Colors.white, // 背景色
                                    foregroundColor: Color(0xFF728873),   // 文字颜色
                                  ),),
                              ),

                            ],
                          ),
                        )
                      ],
                    )
                    )
                  ],
                ),
              ),
            ]
        )
    );
  }
  Future<void> _showInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                exit();
                Navigator.of(context).pop();
                Get.toNamed("/land");
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }
  exit()async{
    final prefs = await SharedPreferences.getInstance();
   await prefs.setBool("is_land",false);
    await prefs.setString("user_email",'');
  }
}
class UserLanding extends StatefulWidget {

  UserLanding({super.key});

  @override
  State<UserLanding> createState() => _UserLandingState();
}

class _UserLandingState extends State<UserLanding> {

  bool is_landing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  init()async{
    final prefs = await SharedPreferences.getInstance();
    var a = (await prefs.getBool("is_land"))!;
    setState(() {
      is_landing = a;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),
          border:Border.all(
              color: Color(0xFF728873),
              width: 2,
              style: BorderStyle.solid
          )
      ),

      child: Column(
        children: [
          if(is_landing)
            GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.person,size: 50,),
                  Text("")
                ],
              ),
              onTap: (){

              },
            ),
          if(!is_landing)
            Container(
              width: 350,
              height: 80,
              child:GestureDetector(
                child: Row(
                  children: [
                    Text("未登录",style: TextStyle(fontSize: 40,color: Colors.green),),
                    Text("点击登录")
                  ],
                ),
                onTap: (){
                  Get.toNamed("/land");
                },
              ),
            )

        ],
      ),
    );
  }
}
