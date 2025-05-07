import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try/Tab/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataBase.dart';
import 'package:logger/logger.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'Base/Item.dart';
import 'main.dart';
// 发送邮箱验证码


var logger = Logger();


class Land extends StatefulWidget {
  const Land({super.key});

  @override
  State<Land> createState() => _LandState();
}

class _LandState extends State<Land> {
  TextEditingController pass_word = new TextEditingController();
  TextEditingController user_name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController code = new TextEditingController();
  bool is_success = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          alignment: Alignment.center,
          child:SizedBox(
            width: 400,
            height: 600,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Expanded(child: TextField(controller: user_name,
                  decoration: InputDecoration(
                      label: Text("用户名"),
                      border: OutlineInputBorder()
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Expanded(child: TextField(controller: pass_word,
                  decoration: InputDecoration(
                      label: Text("密码"),
                      border: OutlineInputBorder()
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Expanded(child: TextField(controller: email,
                  decoration: InputDecoration(
                      label: Text("邮箱"),
                      border: OutlineInputBorder()
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Row(
                    children: [
                      Expanded(
                          child:TextField(controller: code,),
                      ),
                      ElevatedButton(onPressed: (){
                        sendCode(email.text);
                      }, child: Text("获取验证码"))
                    ]
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){Get.back();}, child: Text("返回")),
                    ElevatedButton(onPressed: (){
                      insert_user();
                      if(is_success){Get.back();}
                      else{Get.snackbar("错误", "登录失败");}
                    }, child: Text("登录"))
                  ],
                )
              ],
            ),
          )
        )
      );
  }

  insert_user()async{
    verifyCode("", code.text);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_land", true);
    var ip = prefs.getString("ip");
    logger.d(ip);
    final response = await http.post(
      Uri.parse('http://$ip:8000/insert_user'),
      body: jsonEncode({"name":"1001",'email': "2051824395@qq.com"}),
      headers: {'Content-Type': 'application/json'},
    );
    final utf8Response = utf8.decode(response.bodyBytes);
    print(utf8Response);
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green,
      message: "utf8Response",
      duration: Duration(seconds: 1),
    ));
    //await nodedb.insert_user(new My_User(u_n: user_name.text, p_w: pass_word.text));
    is_success = true;
  }
  get_all_User()async{
    List<My_User> u_l = await nodedb.getAllUser();
    for(var a in u_l){
      logger.d("user :"+a.get_name()+" : "+a.get_password()+" : "+a.get_id());
    }
    logger.d("aaa");
  }

  Future<void> _sendEmail() async {
    String recipient = "2051874395@qq.com";
    if (recipient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入收件人邮箱')),
      );
      return;
    }

    final Email email = Email(
      body: '您的验证码是：1100',
      subject: '邮箱验证码',
      recipients: [recipient],
      isHTML: false,
    );
//default
    //continue
    //default
    //switch
    //virtual
    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码邮件已发送，请查收')),
      );
      logger.d('验证码邮件已发送，请查收');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送邮件失败: $error')),
      );
      logger.d('发送邮件失败: $error');
    }
  }
  Future<void> send() async {
    final Email email = Email(
      body: "111",
      subject: '111',
      recipients: ["2051874395@qq.com"],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      logger.d('验证码邮件已发送，请查收');
    } catch (error) {
      print(error);
      logger.d('发送邮件失败: $error');
    }
  }

  Future<void> sendCode(String email) async {
    final prefs = await SharedPreferences.getInstance();
    var ip = prefs.getString("ip");
    final response = await http.post(
      Uri.parse('http://$ip:8000/send-code'),
      body: jsonEncode({'email': "2051874395@qq.com"}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
  }

// 验证验证码
  Future<void> verifyCode(String email, String code) async {
    final prefs = await SharedPreferences.getInstance();
    var ip = prefs.getString("ip");
    final response = await http.post(
      Uri.parse('http://$ip:8000/verify-code'),
      body: jsonEncode({'email': "2051874395@qq.com", 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    Get.snackbar("code", response.body);
  }
}
//politeness