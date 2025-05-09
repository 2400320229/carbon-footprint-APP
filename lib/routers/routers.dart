
import 'package:flutter_try/Pages/register.dart';
import 'package:get/get.dart';
import '../Pages/land.dart';
import '../main.dart';

class AppPage{
  static final routers = [
    GetPage(name: "/", page: () => MyApp()),
    GetPage(name: "/land", page: () => Land()),
    GetPage(name: "/register", page: () => Register()),
  ];
}