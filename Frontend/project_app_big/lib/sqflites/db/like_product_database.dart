// ignore_for_file: non_constant_identifier_names, avoid_print, unused_import, prefer_const_declarations

import 'dart:math';

import 'package:path/path.dart';
import 'package:project_app_big/models/sqflites/like_product_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class LikeProductDatabase {
  static final LikeProductDatabase instance = LikeProductDatabase._init();

  static Database? _database;

  LikeProductDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('like_products_bd.db');
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
CREATE TABLE $tableLikeProduct ( 
  ${LikeProductFields.id} $idType, 
  ${LikeProductFields.name} $textType,
  ${LikeProductFields.image} $textType,
  ${LikeProductFields.price} $integerType,
  ${LikeProductFields.stock} $integerType,
  ${LikeProductFields.color} $integerType,
  ${LikeProductFields.status} $boolType
  )
''');
  }

  Future<LikeProduct> create(LikeProduct note) async {
    final db = await instance.database;
    
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableLikeProduct, note.toJson());
    return note.copy(id: id);
  }

   Future<String> readLikeProduct_Check(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableLikeProduct,
      columns: LikeProductFields.values,
      where: '${LikeProductFields.id} = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return 'YES';
    } else {
      return 'NO';
    }
  }

  Future<dynamic> readLikeProduct(int id) async {
    final db = await instance.database;
    //print(id);
    final maps = await db.query(
      tableLikeProduct,
      columns: LikeProductFields.values,
      where: '${LikeProductFields.id} = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return LikeProduct.fromJson(maps.first);
    } else {
      return 'NO';
    }
  }
  
  // อ่านค่าทั้งหมด
  Future<List<LikeProduct>> readAllLikeProduct() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableLikeProduct);

    return result.map((json) => LikeProduct.fromJson(json)).toList();
  }
    // อัพเดทจำนวน
 
    
    // ลบ 1 ชิ้น
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableLikeProduct,
      where: '${LikeProductFields.id} = ?',
      whereArgs: [id],
    );
  }
  
  // ลบทุกชิ้น
  Future<void> delete_All() async {
    final db = await instance.database;
    // ดึงข้อมูล
    final data = await db.query(tableLikeProduct);
    // แปลงให้เป็น json
    List<LikeProduct> result =  data.map((json) => LikeProduct.fromJson(json)).toList();
    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        await db.delete(
          tableLikeProduct,
          where: '${LikeProductFields.id} = ?',
          whereArgs: [result[i].id],
        );
      }
    
    }else{
      print("ไม่มีข้อมูล");
    }
    
  }


  Future<int> update(LikeProduct note) async {
    final db = await instance.database;

    return db.update(
      tableLikeProduct,
      note.toJson(),
      where: '${LikeProductFields.id} = ?',
      whereArgs: [note.id],
    );
  }
  

   Future close() async {
    final db = await instance.database;

    db.close();
  }
}
