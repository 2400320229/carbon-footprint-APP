import 'package:flutter/material.dart';
import 'package:flutter_try/Pages/land.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
        page = dataList();
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
        Column()

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
