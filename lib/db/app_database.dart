import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class AppDatabase {
  static final _databaseName = "QuotesDatabase.db";
  static final _databaseVersion = 1;

  Database _client;

  Future<Database> get client async {
    if (_client != null) return _client;
    _client = await _initClient();
    return _client;
  }

  Future<Database> _initClient() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final helper = DatabaseHelper(db: db);

    await helper.createAuthorTable();
    await helper.createQuoteTable();
  }
}
