import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
class My_Node{
  String name;

  My_Node({required this.name});

  Map<String,dynamic> toMap(){
    return {
      "name":name
    };
  }

  factory My_Node.fromMap(Map<String,dynamic> map){
    return My_Node(
      name: map["name"]
    );
  }
  @override
  String toString() {
    return "Node{name:$name}";
  }
}

class My_User{
  String _user_name;
  String _pass_word;
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
      version: 2,
      onCreate: (db,version){
        return Future.wait([
          db.execute("CREATE TABLE nodes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)"),
          db.execute("CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT NOT NULL,password TEXT NOT NULL)"),
          db.execute("CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,count INTEGER NOT NULL,type INTEGER NOT NULL)")
        ]);
      }
    );
  }

  Future<My_Node> create(My_Node node) async {
    final db = await instance.database;
    await db.insert("nodes", node.toMap());
    return node;
  }

  Future<List<My_Node>> readAllNodes() async{
    final db = await instance.database;
    final result = await db.query("nodes");
    return result.map((json)=> My_Node.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  delet(String key) async{
    final db = await instance.database;
    await db.delete("nodes",where: "name = ?",whereArgs: [key]);
    //await db.execute("DELETE nodes WHERE name = ?",[key]);
    //await db.rawDelete("DELETE nodes WHERE name = ?",[key]);//返回删除行数
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