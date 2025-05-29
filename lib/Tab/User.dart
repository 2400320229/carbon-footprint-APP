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
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          child: ElevatedButton(onPressed: (){
                            print("is click");
                            setState(() {
                              is_show_data = true;
                            });
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
                            print("is click");
                            setState(() {
                              is_show_language = true;
                            });
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
                            print("is click");
                            setState(() {
                              is_show_IP = true;
                            });
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
                      ],
                    ),


                  ],
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                right: is_show_data ? 0 : -440, // 从左(0)移动到右(200)
                child: Container(
                  padding: EdgeInsets.only(left: 60,right: 0,top: 10,bottom: 10),
                  color: Colors.white,
                  width: 440,
                  height: 800,
                  child:dataList(show: (){setState(() {
                    is_show_data = false;
                  });})
                )
              ),
              AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  right: is_show_language ? 0 : -440, // 从左(0)移动到右(200)
                  child: Container(
                    padding:EdgeInsets.only(left: 60,right: 0,top: 10,bottom: 10),
                    color: Colors.white,
                    width: 440,
                    height: 800,
                    child:UpdateLanguage(show: (){
                      setState(() {
                        is_show_language = false;
                      });
                    },),
                  )
              ),
              AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  right: is_show_IP ? 0 : -440, // 从左(0)移动到右(200)
                  child: Container(
                    padding:EdgeInsets.only(left: 60,right: 0,top: 10,bottom: 10),
                    color: Colors.white,
                    width: 440,
                    height: 800,
                    child:updateIp(show: (){
                      setState(() {
                        is_show_IP = false;
                      });
                    },),
                  )
              ),
            ]
        )
    );
  }

}
class dataList extends StatefulWidget {
  VoidCallback show;
  dataList({super.key,required this.show});

  @override
  State<dataList> createState() => _dataListState();
}

class _dataListState extends State<dataList> {
  List<CountNode> NodeList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SizedBox(width: 10,),IconButton(onPressed: widget.show, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
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
                Get.toNamed("/land");
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

class UpdateLanguage extends StatefulWidget {
  VoidCallback show;
  UpdateLanguage({super.key,required this.show});

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
        Row(children: [SizedBox(width: 10,),IconButton(onPressed: widget.show, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
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
        ElevatedButton(onPressed: widget.show, child: Text("返回"))
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
        Column()

      ],
    );
  }
}
class updateIp extends StatefulWidget {
  VoidCallback show;
  updateIp({super.key,required this.show});

  @override
  State<updateIp> createState() => _updateIpState();
}

class _updateIpState extends State<updateIp> {
  TextEditingController ip_address = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SizedBox(width: 10,),IconButton(onPressed: widget.show, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
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
