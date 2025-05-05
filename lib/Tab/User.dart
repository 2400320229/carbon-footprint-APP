import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../land.dart';

class User_page extends StatefulWidget {
  const User_page({super.key});

  @override
  State<User_page> createState() => _User_pageState();
}

class _User_pageState extends State<User_page> {
  bool is_show_data = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 50,),
            UserLanding(),
            ElevatedButton(onPressed: (){
              setState(() {
                is_show_data = true;
              });
            }, child: Text('数据')),
            if(is_show_data)
              Expanded(child: dataList(show: (){setState(() {
                is_show_data = false;
              });})
              )
          ],
        ),
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
    return ListView.builder(itemCount: NodeList.length,
        itemBuilder: (BuildContext contex,index){
      return ListTile(
        title: Row(

          children: [
            Text(NodeList[index].count.toString()),
            Text(NodeList[index].type.toString()),
            Text(NodeList[index].date),
            ElevatedButton(onPressed: (){widget.show();}, child: Text("返回"))
          ],
        ),
      );
    });
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
  const UserLanding({super.key});

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
    is_landing = (await prefs.getBool("is_land"))!;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
