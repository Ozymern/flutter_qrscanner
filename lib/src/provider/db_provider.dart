//conexion a la base de datos
import 'dart:io';

import 'package:flutter_qrscanner/src/models/scans_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

export 'package:flutter_qrscanner/src/models/scans_model.dart';

class DBProvider {
  //singleton, para tener solo una instancia de la conexion a base de datos
  static Database _dataBase;

  //DBProvider._(); constructor privado
  static final DBProvider db = DBProvider._();

  //constructor privado
  DBProvider._();

  Future<Database> get database async {
    if (_dataBase != null) {
      return _dataBase;
    }
    _dataBase = await initDB();
    return _dataBase;
  }

  //metodo para crear la base de datos
  initDB() async {
    //definir el path de la base de datos
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //ScanDB.db nombre de mi base de datos
    final path = join(appDocDir.path, 'ScanDB.db');

    //creo la base de datos
    return await openDatabase(path,
        version: 1,
        //metodo que no se ocupara
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      //creo las tablas
      await db.execute('CREATE TABLE scans('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')');
    });
  }

  //metodo para crear registros 1 forma
//  newScanRaw(ScanModel scanModel) async {
//    //verificar si la base de datos esta lista para escribir en ella, database= es nuestro get
//    final db = await database;
//
//    //inserto en la db
//    final result = await db.rawInsert("INSERT INTO scans (id, tyoe,value) "
//        "VALUES (${scanModel.id},'${scanModel.type}','${scanModel.value}')");
//
//    return result;
//  }
//metodo para crear registros 2 forma
  insertScans(ScanModel scanModel) async {
    //    //verificar si la base de datos esta lista para escribir en ella, database= es nuestro get
    final db = await database;

    //agrego un mapa
    final result = await db.insert('scans', scanModel.toMap());

    return result;
  }

  //SELECT WHERE
  Future<ScanModel> getScansId(int id) async {
    final db = await database;

    //retorna una lista de map
    final res = await db.query('scans', where: 'id=?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromMap(res.first) : null;
  }

  //SELECT ALL
  Future<List<ScanModel>> getScansAll() async {
    final db = await database;

    //retorna una lista de map
    final res = await db.query(
      'scans',
    );

    List<ScanModel> list =
        res.isNotEmpty ? res.map((x) => ScanModel.fromMap(x)).toList() : [];
    return list;
  }

  //SELECT por tipo
  Future<List<ScanModel>> getScansForType(String type) async {
    final db = await database;

    //retorna una lista de map
    final res = await db.rawQuery("SELECT * FROM scans WHERE type = '$type'");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((x) => ScanModel.fromMap(x)).toList() : [];
    return list;
  }

  //UPDATE
  Future<int> updateScans(ScanModel scanModel) async {
    final db = await database;

    //retorna un entero
    final res = await db.update('scans', scanModel.toMap(),
        where: 'id=?', whereArgs: [scanModel.id]);

    return res;
  }

  //DELETE
  Future<int> deleteScans(int id) async {
    final db = await database;
    final res = await db.delete('scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  //DELETE ALL
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM scans');
    return res;
  }
}
