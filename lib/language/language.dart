import 'package:get/get.dart';
import 'package:flutter/material.dart';
class Message extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'zh_CN':{
      "holle":"你好",
    },
    "en_US":{
      "holle":"holle"
    }
  };


}