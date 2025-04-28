import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../DataBase.dart';
import 'package:logger/logger.dart';

var logger = Logger();
final nodeDatabase = NodeDataBase.instance;


class Setting_page extends StatefulWidget {

  const Setting_page({super.key});

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {

  List<My_Node> N_L = <My_Node>[].obs;
  TextEditingController NodeName = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    relodeData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 200,
        height: 400,
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child:NodeList(node_list: N_L) ,
            ),
            TextField(controller: NodeName,
            decoration: InputDecoration(
              label:Text("holle".tr),
              border: OutlineInputBorder()
            ),),
            Row(
              children: [
                ElevatedButton(onPressed: () async  {
                  My_Node a = new My_Node(name: NodeName.text);
                  await nodeDatabase.create(a);
                  print("data:::"+await nodeDatabase.readAllNodes().toString());
                  await relodeData();

                }, child: Text("+"))
              ],
            )
          ],
        ),
      ),
    );
  }

  relodeData()async{
    var a = await nodeDatabase.readAllNodes();
    logger.d(a.toString());
    logger.d(N_L.toString());
    setState((){
      N_L = a;
    });

  }
}

class NodeList extends StatefulWidget {
  List<My_Node> node_list = <My_Node>[].obs;
  NodeList({super.key,required this.node_list});

  @override
  State<NodeList> createState() => _NodeListState();
}

class _NodeListState extends State<NodeList> {
  String delete_name = '';
  List<My_Node> node_list = <My_Node>[].obs;
  void _showDialog(String name){
    showDialog(context: context, builder: (BuildContext dialog_context) {
      return AlertDialog(
        content:SizedBox(
          width: 100,
            height: 200,
            child: Column(
              children: [
                Text("是否删除"),
                Row(
                  children: [
                    ElevatedButton(onPressed: () async {
                      await deleteNode(name);
                      Navigator.of(dialog_context).pop();
                    }, child: Text("yes")),
                    ElevatedButton(onPressed: (){
                      Navigator.of(dialog_context).pop();
                    }, child: Text("no"))
                  ],
                )
              ],
            )
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    node_list = widget.node_list;
  }
  @override
  void didUpdateWidget(covariant NodeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.node_list != widget.node_list){
      setState(() {
        node_list = widget.node_list;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: node_list.length,
    itemBuilder: (BuildContext context,int index){
      return ListTile(
        title: Text(node_list[index].name),
        onLongPress: (){
          delete_name = node_list[index].name;
          _showDialog(node_list[index].name);
        },
      );
    },
    );
  }
  deleteNode(String name) async{

    await nodeDatabase.delet(name);
    var a = await nodeDatabase.readAllNodes();
    logger.d(a.toString());
    setState((){
      node_list = a;
    });
  }

}
