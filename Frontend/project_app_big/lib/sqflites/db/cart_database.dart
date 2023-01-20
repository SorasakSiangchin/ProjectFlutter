// ignore_for_file: non_constant_identifier_names, avoid_print, unused_import, prefer_const_declarations

import 'dart:math';

import 'package:path/path.dart';
import 'package:project_app_big/models/sqflites/cart_product_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.name} $textType,
  ${NoteFields.image} $textType,
  ${NoteFields.price} $integerType,
  ${NoteFields.stock} $integerType,
  ${NoteFields.number_product} $integerType
  )
''');
  }

  Future<Cart_Product_Sqflite> create(Cart_Product_Sqflite note) async {
    final db = await instance.database;
    
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert("cart", note.toJson());
    print(id);
    return note.copy(id: id);
  }

  Future<dynamic> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return Cart_Product_Sqflite.fromJson(maps.first);
    } else {
      return 'NO';
    }
  }
  
  // อ่านค่าทั้งหมด
  Future<List<Cart_Product_Sqflite>> readAllNotes() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes);

    return result.map((json) => Cart_Product_Sqflite.fromJson(json)).toList();
  }

  Future<int> cart_number() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    int number_cart = result.map((json) => Cart_Product_Sqflite.fromJson(json)).toList().length;
    return number_cart;
  }
    // อัพเดทจำนวน
  Future<int> update_toCart(Cart_Product_Sqflite note) async {
    final db = await instance.database;
    Cart_Product_Sqflite data ;
    // ----- ค้นหาข้อมูล ------
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    if(maps.isNotEmpty){
      data  = Cart_Product_Sqflite.fromJson(maps.first);
      data.number_product += note.number_product;
    }else{
      throw Exception('ID ${note.id} not found');
    }
    return db.update(
      tableNotes,
      data.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [data.id],
    );
  }
    
    // ลบ 1 ชิ้น
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }
  
  // ลบทุกชิ้น
  Future<void> delete_All() async {
    final db = await instance.database;
    // ดึงข้อมูล
    final data = await db.query(tableNotes);
    // แปลงให้เป็น json
    List<Cart_Product_Sqflite> result =  data.map((json) => Cart_Product_Sqflite.fromJson(json)).toList();
    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        await db.delete(
          tableNotes,
          where: '${NoteFields.id} = ?',
          whereArgs: [result[i].id],
        );
      }
    
    }else{
      print("ไม่มีข้อมูล");
    }
    
  }
  
  // คิดราคารวม
  Future<int> totalPrice() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes);
    List<Cart_Product_Sqflite> data = result.map((json) => Cart_Product_Sqflite.fromJson(json)).toList();
    int price_total = 0;
    for (var i = 0; i < data.length; i++) {
       int price = 0;
       price = data[i].price * data[i].number_product;  
       price_total += price;
    }

    return price_total;
  }

  Future<int> update(Cart_Product_Sqflite note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }
  

   Future close() async {
    final db = await instance.database;

    db.close();
  }
}
