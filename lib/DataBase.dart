
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/land.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
class My_Node{
  String name;
  String? image_path;

  My_Node({required this.name});

  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "path":image_path
    };
  }
  set_image_path(String path){
    this.image_path = path;
  }
  factory My_Node.fromMap(Map<String,dynamic> map){
    try{
      My_Node a = new My_Node(
          name: map["name"],
      );
      a.set_image_path(map["path"]);
      return a;
    }catch(e){
      return My_Node(
          name: map["name"]
      );
    }
  }
  @override
  String toString() {
    return "Node{name:$name}";
  }
}

class My_User{
  String _user_name;
  String _pass_word;
  String? data;
  String id = '';
  My_User({required String u_n,required String p_w}):
        _pass_word = p_w,
        _user_name = u_n;

  set_name(String new_name){
    _user_name = new_name;
  }
  set_id(String id){
    this.id = id;
  }
  get_name(){
    return _user_name;
  }
  get_password(){
    return _pass_word;
  }
  get_id(){
    return id;
  }
}
class NodeDataBase{
  static final NodeDataBase instance = NodeDataBase._init();
  static Database? _database;
  NodeDataBase._init();
  
  Future<Database> get database async {
    if(_database != null)return _database!;
    _database = await _initDB('node.db');
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);
    
    return await openDatabase(
      path,
      version: 6,
      onCreate: (db,version){
        return Future.wait([
          db.execute("CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT NOT NULL,password TEXT NOT NULL)"),
          db.execute("CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,count DOUBLE NOT NULL,type INTEGER NOT NULL,sign TEXT NOT NULL)"),
          db.execute("CREATE TABLE count_nodes(id INTEGER PRIMARY KEY AUTOINCREMENT, count DOUBLE NOT NULL,type INT NOT NULL,date TEXT NOT NULL)")
        ]);
      }
    );
  }

  Future<Item> insert_Item(Item a)async{
    final db = await instance.database;
    db.insert("items", a.toMap());
    return a;
  }

  Future<CountNode> insert_CountNode(CountNode a)async{
    final db = await instance.database;
    db.insert("count_nodes", a.toMap());
    return a;
  }

  delet_CountNode()async{
    final db = await instance.database;
    await db.delete('count_nodes');
  }

  delet_Item(String name)async {
    final db = await instance.database;
    db.delete("item",where:"name = ?",whereArgs: [name]);
  }
  Future<List<Item>> get_ItemList(int type) async {
    try {
      final db = await instance.database;
      // 检查数据库是否成功打开
      if (db == null) {
        print('Database is not initialized.');
        return [];
      }
      final _ItemList = await db.query("items", where: "type = ?", whereArgs: [type]);
      logger.d('Query result: ${_ItemList.toString()}, Query type: ${type.toString()}');
      if (_ItemList.isEmpty) {
        print('No data found for type: $type');
      }
      List<Item> result = _ItemList.map((json) => Item.fromMap(json)).toList();
      return result;
    } catch (e) {
      print('Error getting item list: $e');
      rethrow;
    }
  }
  Future<Map<String,List<Item>>>get_allItem()async{
    List<Item> yi_Item_List = await get_ItemList(1);
    List<Item> shi_Item_List = await get_ItemList(2);
    List<Item> zhu_Item_List = await get_ItemList(3);
    List<Item> xing_Item_List = await get_ItemList(4);
    return{
      "1":yi_Item_List,
      "2":shi_Item_List,
      "3":zhu_Item_List,
      "4":xing_Item_List,
    };
  }
  Future<List<CountNode>> getAllCountNode()async{
    final db = await instance.database;
    final result = await db.query("count_nodes");
    return result.map((json)=> CountNode.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }


  delet_all_CountNode()async{
    final db = await instance.database;
    db.delete("count_nodes");
  }

  Future<String>getPassWordByUserName(String key)async{
    final db = await instance.database;
    final result = await db.query("users",
      where: "user_name = ?",
      whereArgs: [key],
      columns: ["password"]);
    if(result.isNotEmpty){
      return result[0].toString();
    }
    return "null";
  }
  
  Future<void> insert_user(My_User us) async {
    final db = await instance.database;
    db.insert("users", {"user_name":us._user_name,"password":us._pass_word});
  }
  
  Future<List<My_User>> getAllUser()async{
    final db = await instance.database;
    final US_List = await db.query("users");
    List<My_User> result = [];
    if(US_List.length == 0){
      return [];
    }
    for(int i = 0;i<US_List.length;i++){
      My_User one =  new My_User(u_n: US_List[i]["user_name"].toString(), p_w:  US_List[i]["password"].toString());
      one.set_id(US_List[i]["id"].toString());
      result.add(one);

    }
    return result;
  }
}