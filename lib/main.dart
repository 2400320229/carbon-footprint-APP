import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Tab/Category.dart';
import 'package:flutter_try/Tab/Setting.dart';
import 'package:flutter_try/Tab/Home.dart';

import 'package:flutter_try/language/language.dart';
import 'package:flutter_try/routers/routers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataBase.dart';

final nodedb = NodeDataBase.instance;
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int currentIndex=0;
  List<Widget>Page=[
    Home_page(),
    Category_page(),
    Setting_page()
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
      translations: Message(),
      locale: Locale("zh","CN"),
      fallbackLocale: Locale("en","US"),
      initialRoute: "/",
      defaultTransition: Transition.rightToLeftWithFade,
      getPages: AppPage.routers,
        home: Scaffold(
      appBar: AppBar(
        title: Text("holle".tr),
      ),
      body: Page[currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        fixedColor: Colors.green,
          currentIndex: currentIndex,
          onTap: (index){
          setState(() {
            currentIndex=index;
          });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.category),label: "category"),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: "settings")
          ]),
    ));
  }
}

class MyButton extends StatelessWidget {
  int n;
  MyButton(this.n, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  print("普通按钮");
                },
                child: Text("66")),
            TextButton(
                onPressed: () {
                  print("文本按钮");
                },
                child: Text("文本按钮")),
            IconButton(
                onPressed: () {
                  print("图标按钮");
                },
                icon: Icon(Icons.thumb_up))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ElevatedButton.icon(
                onPressed: () {
                  print("o~y~");
                  print(n++);
                },
                label: Text("添加"),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.cyan), //背景颜色
                    foregroundColor:
                        WidgetStateProperty.all(Colors.white), //图标颜色
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10) //设置圆角
                        )),
                    side: WidgetStateProperty.all(
                        BorderSide(width: 2, color: Colors.red)) //设置边框
                    ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> myList = [];
  void _addItem(text) {
    setState(() {
      myList.add(text);
    });
  }

  void _deleteItem() {
    setState(() {
      myList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Flexible(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 200,
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Button_x(
                        text: "1",
                        onPressed: () {
                          _addItem('1');
                        },
                      ),
                      Button_x(
                        text: "2",
                        onPressed: () {
                          _addItem('2');
                        },
                      ),
                      Button_x(
                        text: "3",
                        onPressed: () {
                          _addItem('3');
                        },
                      ),
                      Button_x(
                        text: "4",
                        onPressed: () {
                          _addItem('4');
                        },
                      ),
                      Button_x(
                        text: "5",
                        onPressed: () {
                          _addItem('5');
                        },
                      )
                    ],
                  ))),
          Divider(height: 2),
          Flexible(
            flex: 2,
            child: SizedBox(
                width: double.infinity,
                height: 300,
                child: Expanded(
                    child: ListView(
                  padding: EdgeInsets.all(1),
                  children: myList.map((item) {
                    return Column(children: <Widget>[
                      ListTile(
                        title: Text(item),
                      ),
                      Divider()
                    ]);
                  }).toList(),
                ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    _deleteItem();
                  },
                  child: Row(children: [Icon(Icons.local_see), Text("清空记录")])),
            ],
          )
        ],
      ),
    );
  }
}

class NEWListView extends StatelessWidget {
  NEWListView({super.key}) {
    print("dd");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(color: Colors.white30),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(1),
        children: <Widget>[],
      ),
    );
  }
}

class MyGridview extends StatelessWidget {
  MyGridview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 200,
      decoration: BoxDecoration(color: Colors.blue),
      child: GridView.extent(
          maxCrossAxisExtent: 50, //横轴子元素最大宽度
          padding: EdgeInsets.all(10),
          children: const [
            Icon(Icons.book, color: Colors.green),
            Icon(Icons.bike_scooter, color: Colors.green),
            Icon(Icons.book, color: Colors.green),
            Icon(Icons.book, color: Colors.green),
            Icon(Icons.book, color: Colors.green),
            Icon(Icons.book, color: Colors.green),
            Icon(Icons.book, color: Colors.green),
          ]),
    );
  }
}

class Button_x extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  Button_x({required this.text, this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // 点击按钮时调用传入的onPressed函数
      child: Text(text), // 显示传入的文本
      style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          side: WidgetStateProperty.all(
              BorderSide(width: 2, color: Colors.white12))),
    );
  }
}


void init_app()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var list = await nodedb.get_allItem();
  bool? is_add = await prefs.getBool("is_add_data");
  if(list["1"]!.isNotEmpty){
    logger.d("have_value");
    logger.d(list);
  }else{
    logger.d("is_load");
    await add_data();
    prefs.setBool("is_add_data", true);
  }

}
add_data()async {
  var List = [
    new Item(name: "1", count: 2, type: 1),
    new Item(name: "2", count: 3, type: 1),
    new Item(name: "1", count: 2, type: 2),
    new Item(name: "3", count: 2, type: 2),
    new Item(name: "4", count: 2, type: 3),
    new Item(name: "1", count: 2, type: 3),
    new Item(name: "2", count: 2, type: 4),
    new Item(name: "1", count: 2, type: 4)
  ];
  for(Item a in List){
    nodedb.insert_Item(a);
  }
}