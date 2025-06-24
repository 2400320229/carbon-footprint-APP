import 'package:flutter/material.dart';

import '../Base/Item.dart';


String in_background =
    "中国是世界上最大的碳排放国家之-，其碳足迹发展现状在过去几年有所改善，"
    "但仍然面临挑战。在这样的情况下，一款用来计算常见产品的碳排放，让用户了解该产品的碳排放量，"
    "并且能将用户的碳排放记录下来，并将其可视化的软件，正是双碳行动中所需要的，"
    "我们的碳足迹计算器也应运而生";
String in_use =
    "我们的产品计算界面采用了单个产品单次计算的方式，"
    "这样有助于用户不仅能了解每个产品的碳排放的同时，也能够把自己对应的碳排放行为记录下来，"
    "有了碳排放的记录，或许还不够，所以我们还有可视化图表来形象展现用户产生的数据，"
    "用户能够更加精准地知道自己的最近产生碳足迹的信息";
//一.软件背景
String in_knowledge1 = "1.什么是碳足迹？\n"
"碳足迹是指个人、组织或活动直接或间接产生的温室气体（如CO₂）排放总量，通常以二氧化碳当量（CO₂e）计算。\n"
"2.碳足迹的单位\n"
"常用“千克CO₂e”或“吨CO₂e”表示，例如1吨CO₂e约等于一辆汽车行驶4000公里的排放量。\n"
"3.直接排放 vs 间接排放\n"
"直接排放来自自身行为（如开车），间接排放来自购买的商品或服务（如电力、食品生产）。\n";
String in_knowledge2 =
"1.普通人一天的碳足迹\n"
"全球人均日碳足迹约12-20kg CO₂e，发达国家可能高达30kg以上。\n"
"2.洗澡的碳排放\n"
"10分钟淋浴（燃气热水器）约排放0.5kg CO₂e，电热水器可能更高。\n"
"3.待机耗电的隐藏排放\n"
"家电待机模式占家庭用电的5%-10%，拔掉插头每年可减排数百千克CO₂e。\n"
"4.空调的温度设定\n"
"夏季空调每调高1℃，可减少约3%的能耗，冬季暖气调低1℃同理。\n"
"5.LED灯的节能效果\n"
"相比白炽灯，LED灯节能80%，寿命长25倍。\n";
//
// 二.软件用途

List<Item>List_data = [
  new Item(name: "cotton_T_shirt", count: 1.4, type: 1,sign: "0.2kg"),
  new Item(name: "Polyester_T_shirt", count: 1.1, type: 1,sign: "0.2kg"),
  new Item(name: "cotton_shirt", count: 2.1, type: 1,sign: "0.3kg"),
  new Item(name: "Hemp_shirt", count: 1.5, type: 1,sign: "kg"),
  new Item(name: "woolen_coat", count: 10, type: 1,sign: "kg"),
  new Item(name: "silk_scarf", count: 0.8, type: 1,sign: "kg"),
  new Item(name: "chicken", count: 5.3, type: 2,sign: "kg"),
  new Item(name: "beef", count: 26.5, type: 2,sign: "kg"),
  new Item(name: "pork", count: 5.2, type: 2,sign: "kg"),
  new Item(name: "mutton", count: 22.7, type: 2,sign: "kg"),
  new Item(name: "duck_meat", count: 7, type: 2,sign: "kg"),
  new Item(name: "tomatoes", count: 0.5, type: 2,sign: "kg"),
  new Item(name: "cucumbers", count: 0.6, type: 2,sign: "kg"),
  new Item(name: "potatoes", count: 0.4, type: 2,sign: "kg"),
  new Item(name: "flour", count: 0.8, type: 2,sign: "kg"),
  new Item(name: "water", count: 0.2, type: 2,sign: "500ml"),
  new Item(name: "coffee", count: 0.3, type: 2,sign: "250ml"),
  new Item(name: "conditioner", count: 0.6, type: 3,sign: "h"),
  new Item(name: "TV", count: 0.12, type: 3,sign: "h"),
  new Item(name: "refrigerator", count: 0.06, type: 3,sign: "h"),
  new Item(name: "washing_machine", count: 0.32, type: 3,sign: "h"),
  new Item(name: "water_heater", count: 1.6, type: 3,sign: "h"),
  new Item(name: "computer", count: 0.22, type: 3,sign: "h"),
  new Item(name: "smartphone", count: 0.005, type: 3,sign: "h"),
  new Item(name: "LED", count: 0.007, type: 3,sign: "kg"),
  new Item(name: "paper", count: 1.2, type: 3,sign: "kg"),
  new Item(name: "gasoline_car", count: 0.18, type: 4,sign: "km"),
  new Item(name: "Bus", count: 0.013, type: 4,sign: "km"),
  new Item(name: "Subway", count: 0.015, type: 4,sign: "km"),
  new Item(name: "Airplane", count: 0.04, type: 4,sign: "km"),
  new Item(name: "New_energy_vehicle", count: 0.12, type: 4,sign: "km"),
  new Item(name: "Motorcycle", count: 0.1, type: 4,sign: "km"),
  new Item(name: "bike", count: 0.035, type: 4,sign: "km"),
  new Item(name: "Cruise_ship", count: 0.08, type: 4,sign: "km"),


];
List<List<Item>>List_o_data = [
  [new Item(name: "cotton_T_shirt", count: 1.4, type: 1,sign: "0.2kg"),
    new Item(name: "Polyester_T_shirt", count: 1.1, type: 1,sign: "0.2kg"),
    new Item(name: "cotton_shirt", count: 2.1, type: 1,sign: "0.3kg"),
    new Item(name: "Hemp_shirt", count: 1.5, type: 1,sign: "kg"),
    new Item(name: "woolen_coat", count: 10, type: 1,sign: "kg"),
    new Item(name: "silk_scarf", count: 0.8, type: 1,sign: "kg"),],
  [new Item(name: "chicken", count: 5.3, type: 2,sign: "kg"),
    new Item(name: "beef", count: 26.5, type: 2,sign: "kg"),
    new Item(name: "pork", count: 5.2, type: 2,sign: "kg"),
    new Item(name: "mutton", count: 22.7, type: 2,sign: "kg"),
    new Item(name: "duck_meat", count: 7, type: 2,sign: "kg"),
    new Item(name: "tomatoes", count: 0.5, type: 2,sign: "kg"),
    new Item(name: "cucumbers", count: 0.6, type: 2,sign: "kg"),
    new Item(name: "potatoes", count: 0.4, type: 2,sign: "kg"),
    new Item(name: "flour", count: 0.8, type: 2,sign: "kg"),
    new Item(name: "water", count: 0.2, type: 2,sign: "500ml"),
    new Item(name: "coffee", count: 0.3, type: 2,sign: "250ml"),],
  [new Item(name: "conditioner", count: 0.6, type: 3,sign: "h"),
    new Item(name: "TV", count: 0.12, type: 3,sign: "h"),
    new Item(name: "refrigerator", count: 0.06, type: 3,sign: "h"),
    new Item(name: "washing_machine", count: 0.32, type: 3,sign: "h"),
    new Item(name: "water_heater", count: 1.6, type: 3,sign: "h"),
    new Item(name: "computer", count: 0.22, type: 3,sign: "h"),
    new Item(name: "smartphone", count: 0.005, type: 3,sign: "h"),
    new Item(name: "LED", count: 0.007, type: 3,sign: "kg"),
    new Item(name: "paper", count: 1.2, type: 3,sign: "kg"),],
  [new Item(name: "gasoline_car", count: 0.18, type: 4,sign: "km"),
    new Item(name: "Bus", count: 0.013, type: 4,sign: "km"),
    new Item(name: "Subway", count: 0.015, type: 4,sign: "km"),
    new Item(name: "Airplane", count: 0.04, type: 4,sign: "km"),
    new Item(name: "New_energy_vehicle", count: 0.12, type: 4,sign: "km"),
    new Item(name: "Motorcycle", count: 0.1, type: 4,sign: "km"),
    new Item(name: "bike", count: 0.035, type: 4,sign: "km"),
    new Item(name: "Cruise_ship", count: 0.08, type: 4,sign: "km"),]

];