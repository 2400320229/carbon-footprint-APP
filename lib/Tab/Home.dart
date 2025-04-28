import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter_try/land.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home_page extends StatefulWidget {
  const Home_page({super.key});
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {

  String _recognizedText = '';
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  TextEditingController massage = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 200,
            ),
          SizedBox(
            child: Text(_recognizedText),
            width: 100,
            height: 100,
          ),
          ElevatedButton(onPressed: ()=>{
              _pickImage()
          }, child: Text("选择照片")),
          ElevatedButton(onPressed: (){
            /*Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const Land())
            );*/
            //Get.toNamed("/land",arguments: {"value":"你点击了登录"});
            sendCode("2051874395@qq.com");
          }, child: Text('登录')),
          ElevatedButton(onPressed: (){
           var locale = Locale("zh","CN");
           Get.updateLocale(locale);
          }, child: Text('CN')),
          ElevatedButton(onPressed: (){
            var locale = Locale("en","US");
            Get.snackbar("en", "US",backgroundColor: Colors.green);
            Get.updateLocale(locale);
          }, child: Text('US'))
        ],
      ),
    );
  }
  Future<void> sendCode(String email) async {
    /*final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/send-code'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );*/
    var address = await getLocalIPAddresses();
    var address1 = address[0];
    final response = await http.get(Uri.parse("http://10.33.120.2:8080/send-code?email=$email"));
    print(response.body);
  }
  Future<List<String>> getLocalIPAddresses() async {
    List<String> ipAddresses = [];
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type.name == 'IPv4') {
            ipAddresses.add(addr.address);
          }
        }
      }
    } catch (e) {
      print('获取 IP 地址时出错: $e');
    }
    return ipAddresses;
  }
}
