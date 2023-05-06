import 'package:path/path.dart';
import 'package:resep_makanan/model/resep_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  final String _tableName = 'reseps';

  Future<Database> _initializeDb() async {
    var db = openDatabase(join(await getDatabasesPath(), 'reseps_db.db'),
        onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        ingredients TEXT,
        step TEXT,
        picture BLOB)''',
      );
    }, version: 1);
    return db;
  }

  Future<void> insertResep(Resep resep) async {
    final Database db = await database;
    await db.insert(_tableName, resep.toMap());
  }

  Future<List<Resep>> getResep() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((e) => Resep.fromMap(e)).toList();
  }

  Future<Resep> getResepById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.map((e) => Resep.fromMap(e)).first;
  }

  Future<void> updateResep(int id, Resep resep) async {
    final db = await database;
    await db.update(
      _tableName,
      resep.toMap(),
      where: 'id = ?',
      whereArgs: [resep.id],
    );
  }

  Future<void> deleteResep(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Resep>> searchData(String keyword) async {
    final db = await database;
    var res = await db
        .query(_tableName, where: "name LIKE ?", whereArgs: ['%$keyword%']);
    List<Resep> list =
        res.isNotEmpty ? res.map((c) => Resep.fromMap(c)).toList() : [];
    return list;
  }
}
