import 'dart:io';

import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dao.dart';
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

    await _setupSampleData(db);
  }

  // TODO Remove this method
  Future<void> _setupSampleData(Database db) async {
    final dao = Dao(db);
    final author1 = Author(id: 1, firstName: "Albert", lastName: "Einstein");
    final quote1 = Quote(
      id: 1,
      author: author1,
      content: "A person who never made a mistake never tried anything new.",
    );
    final quote2 = Quote(
      id: 2,
      author: author1,
      content:
          "Imagination is everything. It is the preview of life\'s coming attractions.",
    );

    await dao.addAuthor(author1);
    await dao.addQuote(quote1);
    await dao.addQuote(quote2);

    final author2 = Author(id: 2, firstName: "Janis", lastName: "Joplin");
    final quote3 = Quote(
      id: 3,
      author: author2,
      content: "I\'d trade all my tomorrows for a single yesterday.",
    );

    await dao.addAuthor(author2);
    await dao.addQuote(quote3);

    final author3 = Author(id: 3, firstName: "Audrey", lastName: "Hepburn");
    final quote4 = Quote(
      id: 4,
      author: author3,
      content: "If I get married, I want to be very married.",
    );

    await dao.addAuthor(author3);
    await dao.addQuote(quote4);

    final author4 = Author(id: 4, firstName: "Alan", lastName: "Watts");
    final quote5 = Quote(
      id: 5,
      author: author4,
      content:
          "The only way to make sense out of change is to plunge into it, move with it, and join the dance.",
    );

    await dao.addAuthor(author4);
    await dao.addQuote(quote5);

    final author5 = Author(id: 5, firstName: "Mark", lastName: "Twain");
    final quote6 = Quote(
      id: 6,
      author: author5,
      content:
          "The man who does not read has no advantage over the man who cannot read.",
    );

    await dao.addAuthor(author5);
    await dao.addQuote(quote6);
  }
}
