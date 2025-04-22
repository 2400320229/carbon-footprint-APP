import 'package:flutter/material.dart';


List<String> node_l = ["1",'2'];
class Category_page extends StatefulWidget {
  const Category_page({super.key});

  @override
  State<Category_page> createState() => _Category_pageState();
}

class _Category_pageState extends State<Category_page> {

  var add_node = new TextEditingController();
  void _showFragment(){
    showDialog(context: context, builder: (BuildContext dialog_context) {
      return AlertDialog(
        content:SizedBox(
        width: 200,
        height: 200,
        child: Column(
          children: [
            SizedBox(
              width: 150,
              height: 100,
              child:TextField(
                controller: add_node,
                decoration: InputDecoration(
                    label: Text('请输入文本'),
                    border: OutlineInputBorder()
                ),
              ),
            ),

            ElevatedButton(onPressed: ()=>{
              setState(() {
                if(add_node.text.isNotEmpty){
                  node_l.add(add_node.text);
                }
                Navigator.of(dialog_context).pop();
              })
            }, child: Text("确定"))
          ],
        ),
        )
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text("data"),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: NodeList(),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: ()=>{
                  setState(() {
                    _showFragment();
                  })
                }, child: Text("添加")),
                ElevatedButton(onPressed: ()=>{
                  setState(() {
                    node_l.clear();
                  })
                }, child: Text("删除")),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class NodeList extends StatefulWidget {
  const NodeList({super.key});

  @override
  State<NodeList> createState() => _NodeListState();
}

class _NodeListState extends State<NodeList> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: node_l.length,
        itemBuilder: (BuildContext context,int index){
           return ListTile(
             title: Text(node_l[index]),
           );
        }
    );
  }
}



