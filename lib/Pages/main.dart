import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Tab/Category.dart';
import 'package:flutter_try/Tab/Setting.dart';
import 'package:flutter_try/Tab/Home.dart';
import 'package:flutter_try/Tab/User.dart';
import 'package:flutter_try/language/language.dart';
import 'package:flutter_try/routers/routers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/DataBase.dart';
import '../model/String.dart';

Map<String,List<Item>> all_ItemList = {};

final nodedb = NodeDataBase.instance;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(Duration.zero, () async {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String language = 'zh_CN';
  int currentIndex=0;
  List<Widget>Page=[
    Home_page(),
    Category_page(),
    DataPage(),
    User_page()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_app();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
      translations: Message(),
      locale: Locale(language.split("_")[0],language.split("_")[1]),
      fallbackLocale: Locale("en","US"),
      initialRoute: "/",
      defaultTransition: Transition.rightToLeftWithFade,
      getPages: AppPage.routers,
        home: Scaffold(
      body: Page[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        fixedColor: Colors.green,
          unselectedItemColor: Colors.black12,
          currentIndex: currentIndex,
          onTap: (index){
          setState(() {
            currentIndex=index;
          });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "计算"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icons/question.png')),label: "AI"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icons/Summery.png')),label: "统计"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "用户")
          ]),
    ));
  }
  void init_app()async{

    logger.d("welcome!");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("language","zh_CN");
    bool? is_load = await prefs.getBool("is_load");
    if(is_load != true){
        logger.d("is_not_load");
        await add_data();
        await prefs.setBool("is_load", true);
    }else{
      all_ItemList = await nodedb.get_allItem();
    }
    var a = prefs.getString("language");
    setState(() {
      print(language);
      language = a.toString();
    });
  }
  add_data()async {
    for(Item a in List_data){
      nodedb.insert_Item(a);
    }
  }
}


