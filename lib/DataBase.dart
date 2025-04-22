import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Node{
  String name;

  Node({required this.name});

  Map<String,dynamic> toMap(){
    return {
      "name":name
    };
  }

  factory Node.fromMap(Map<String,dynamic> map){
    return Node(
      name: map["name"]
    );
  }
  @override
  String toString() {
    return "Node{name:$name}";
  }
}

class User{
  String _user_name;
  num _pass_word;
  int id;
  User({required String u_n,required num p_w,required id}):
        _pass_word = p_w,
        _user_name = u_n,
        id = id;
  int get_id(){
    return id;
  }
  set_name(String new_name){
    _user_name = new_name;
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
          db.execute("CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT NOT NULL,password TEXT NOT NULL)")
        ]);
      }
    );
  }

  Future<Node> create(Node node) async {
    final db = await instance.database;
    await db.insert("nodes", node.toMap());
    return node;
  }

  Future<List<Node>> readAllNodes() async{
    final db = await instance.database;
    final result = await db.query("nodes");
    return result.map((json)=> Node.fromMap(json)).toList();
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
}