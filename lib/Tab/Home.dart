import 'dart:convert';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  TextEditingController massage = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            child: Text(massage.text),
            width: 100,
            height: 100,
          ),
          TextField(
            controller: massage,
            decoration: InputDecoration(
              label: Text('请输入文本'),
              border: OutlineInputBorder()
            ),
          ),
          ElevatedButton(onPressed: ()=>{
            setState(() async {
              //massage.text = "你点击了home";
              try {
                var response =  await http.get(Uri.parse("https://www.baidu.com/"));
                if (response.statusCode == 200) {
                  // 请求成功，解析响应数据
                  setState(() {
                    massage.text = json.decode(response.body).toString();
                  });
                } else {
                  // 请求失败，输出错误信息
                  setState(() {
                    massage.text = '请求失败: ${response.statusCode}';
                  });
                }
              }catch(e){
                massage.text = "fail";
              }
            })
          }, child: Text("按钮"))
        ],
      ),
    );
  }
}
