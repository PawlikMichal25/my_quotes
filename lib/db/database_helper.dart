import 'package:my_quotes/db/tables.dart';
import 'package:sqflite/sqflite.dart' as Sqflite;

class DatabaseHelper {
  final Sqflite.Database db;

  DatabaseHelper({this.db});

  Future<void> createAuthorTable() async {
    return db.execute('''
      CREATE TABLE ${Tables.authorTableName} (
        ${Tables.authorColumnID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        ${Tables.authorColumnFirstName} TEXT NOT NULL, 
        ${Tables.authorColumnLastName} TEXT NOT NULL
      );''');
  }

  Future<void> createQuoteTable() async {
    await db.execute('''
      CREATE TABLE ${Tables.quoteTableName} (
        ${Tables.quoteColumnId} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${Tables.quoteColumnAuthorId} INTEGER NOT NULL, 
        ${Tables.quoteColumnContent} TEXT NOT NULL, 
        FOREIGN KEY(${Tables.quoteColumnAuthorId}) REFERENCES ${Tables.authorTableName}(${Tables.authorColumnID})
      );''');
  }
}
