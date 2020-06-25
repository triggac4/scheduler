import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/todoModel.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper;
  static Database _database;

  String table = 'todo';
  String id = 'id';
  String title = 'title';
  String description = 'description';
  String urgency = 'urgency';
  String date = 'date';

  DatabaseHelper.createinstance();

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.createinstance();
      return databaseHelper;
    }
    return databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathz = directory.path + 'todo.db';
    return openDatabase(pathz, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT,$description TEXT,$urgency TEXT,$date TEXT)');
    });
  }

  Future<int> insert(TodoModel todo) async {
   
    Database db = await database;
    return db.rawInsert(
        'insert into $table($title,$urgency,$date,$description)values(?,?,?,?)',
        [todo.title, todo.urgency, todo.formattedDate, todo.description]);
  }

  Future<int> update(TodoModel todo) async {
    Map<String, dynamic> tomap = {
      'title': todo.title,
      'id': todo.id,
      'urgency': todo.urgency,
      'description': todo.description,
      'date': todo.formattedDate
    };
    Database db = await database;
    return db.update(table, tomap, where: '$id=?', whereArgs: [todo.id]);
  }

  Future<int> delete(TodoModel todo) async {
    Database db = await this.database;
    return db.delete(table, where: '$id=?', whereArgs: [todo.id]);
  }
  createTable(Database db ,int version)async{
      return db.execute(
          'CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT,$description TEXT,$urgency TEXT,$date TEXT)');
    
  }


  Future<void> deleteTable() async {
    try {
      Database db = await database;
      return db.execute('DROP TABLE $table');
    } catch (e) {
      return;
    }
  }

  Future<List<Map<String, dynamic>>> getMapTodList() async {
    _database = null;
    Database db = await database;
    
      var vap = await db.rawQuery('SELECT* FROM $table');

      if (vap.isEmpty) {
        return null;
      } else {
        return vap;
      }
  }
  Future<List<TodoModel>> todo() async {
    List<TodoModel> tod = [];
    var map = await getMapTodList();
    if (map == null) {
      Database db=await database;
      deleteTable().then((err){
      createTable(db, 1);
        });
      print('empty');
    return [];
    }
   map.forEach((ma){
     tod.add(TodoModel.totodolist(ma));
   });
      return tod;
  }
}
