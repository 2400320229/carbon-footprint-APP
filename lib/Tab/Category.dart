import 'package:flutter/material.dart';
import 'package:flutter_try/AIrequest/request.dart';


List<String> node_l = ["1",'2'];
class Category_page extends StatefulWidget {
  const Category_page({super.key});

  @override
  State<Category_page> createState() => _Category_pageState();
}

class _Category_pageState extends State<Category_page> {

  AIService deepseek = new AIService();
  var respone = '';

  chat()async{
    var result = await deepseek.getChatCompletion("你好");
    setState(() {
      respone = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(respone.toString()),
          ElevatedButton(onPressed:(){chat();} , child: Text("chat"))
        ],
      ),
    );
  }
}




