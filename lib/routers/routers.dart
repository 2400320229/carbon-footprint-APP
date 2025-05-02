
import 'package:get/get.dart';

import '../New.dart';
import '../land.dart';

class AppPage{
  static final routers = [
    GetPage(name: "/", page: () => MyApp()),
    GetPage(name: "/land", page: () => Land()),
  ];
}