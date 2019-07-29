import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as Sqflite;

import 'dao.dart';
import 'database_helper.dart';

class Database {
  static final _databaseName = "QuotesDatabase.db";
  static final _databaseVersion = 1;

  Database._();

  static final Database instance = Database._();

  static Sqflite.Database _client;

  Future<Sqflite.Database> get client async {
    if (_client != null) return _client;
    _client = await _initClient();
    return _client;
  }

  Future<Sqflite.Database> _initClient() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await Sqflite.openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Sqflite.Database db, int version) async {
    final helper = DatabaseHelper(db: db);

    await helper.createAuthorTable();
    await helper.createQuoteTable();
  }

  Future<Dao> getDao() async {
    final db = await client;
    return Dao(db: db);
  }
}
