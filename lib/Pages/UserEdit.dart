import 'package:flutter/material.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({super.key});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(),
      ),
      body:Column(
        children: [
          Container(
            child:Column(
              children: [
                //Image(image: image)
                Text("用户名"),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                //buttons...
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: (){}, child: Text("返回")),
              ElevatedButton(onPressed: (){}, child: Text("保存")),
            ],
          )
        ],
      ),
    );
  }
}

class SelectImage extends StatefulWidget {

  const SelectImage({super.key});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  List<String> imageList = ["1",'2','3','4','5'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0x5E040404),
              ),
            ),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              child: Expanded(child: ListView.builder(
                itemCount: imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Container(
                      child: Image.asset("images/user/${imageList[index]}.jpg"),
                    ),
                  );
                },
              )),
            )
          ],
        )
      ],
    );
  }
}

