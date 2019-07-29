import 'package:my_quotes/db/tables.dart';
import 'package:sqflite/sqlite_api.dart' as Sqflite;

import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';

class Dao {
  final Sqflite.Database db;

  Dao({this.db});

  Future<Author> addAuthor(Author author) async {
    Map<String, dynamic> row = {
      Tables.authorColumnFirstName: author.firstName,
      Tables.authorColumnLastName: author.lastName
    };

    final id = await db.insert(Tables.authorTableName, row);
    return Author(
      id: id,
      firstName: author.firstName,
      lastName: author.lastName,
    );
  }

  Future<Quote> addQuote(Quote quote) async {
    Map<String, dynamic> row = {
      Tables.quoteColumnAuthorId: quote.author.id,
      Tables.quoteColumnContent: quote.content
    };

    final id = await db.insert(Tables.quoteTableName, row);
    return Quote(
      id: id,
      author: quote.author,
      content: quote.content,
    );
  }

  Future<List<Author>> getAllAuthors() async {
    final results = await db.query(Tables.authorTableName);
    return results
        .map(
          (row) => Author(
            id: row[Tables.authorColumnID],
            firstName: row[Tables.authorColumnFirstName],
            lastName: row[Tables.authorColumnLastName],
          ),
        )
        .toList();
  }
}
