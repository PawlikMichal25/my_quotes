import 'package:my_quotes/db/tables.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';

class Dao {
  final Database db;

  Dao(this.db);

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

  Future<List<Quote>> getQuotes(int authorId) async {
    if (authorId == null) {
      return getAllQuotes();
    } else {
      return getQuotesWithAuthorId(authorId);
    }
  }

  Future<List<Quote>> getAllQuotes() async {
    final query = '''
    SELECT ${Tables.quoteColumnId}, ${Tables.quoteColumnContent}, 
    ${Tables.authorTableName}.${Tables.authorColumnID}, ${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}
    FROM ${Tables.quoteTableName}
    INNER JOIN ${Tables.authorTableName}
    ON ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == ${Tables.authorTableName}.${Tables.authorColumnID}
    ''';

    final results = await db.rawQuery(query);

    return results.map(
      (row) {
        final author = Author(
          id: row[Tables.authorColumnID],
          firstName: row[Tables.authorColumnFirstName],
          lastName: row[Tables.authorColumnLastName],
        );

        final quote = Quote(
          id: row[Tables.quoteColumnId],
          author: author,
          content: row[Tables.quoteColumnContent],
        );

        return quote;
      },
    ).toList();
  }

  Future<List<Quote>> getQuotesWithAuthorId(int authorId) async {
    final query = '''
    SELECT ${Tables.quoteColumnId}, ${Tables.quoteColumnContent}, 
    ${Tables.authorTableName}.${Tables.authorColumnID}, ${Tables.authorColumnFirstName}, ${Tables.authorColumnLastName}
    FROM ${Tables.quoteTableName}
    INNER JOIN ${Tables.authorTableName}
    ON ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == ${Tables.authorTableName}.${Tables.authorColumnID} 
    WHERE ${Tables.quoteTableName}.${Tables.quoteColumnAuthorId} == $authorId
    ''';

    final results = await db.rawQuery(query);

    return results.map(
      (row) {
        final author = Author(
          id: row[Tables.authorColumnID],
          firstName: row[Tables.authorColumnFirstName],
          lastName: row[Tables.authorColumnLastName],
        );

        final quote = Quote(
          id: row[Tables.quoteColumnId],
          author: author,
          content: row[Tables.quoteColumnContent],
        );

        return quote;
      },
    ).toList();
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

  Future<int> getIdOfAuthorWith({String firstName, String lastName}) async {
    final results = await db.query(
      Tables.authorTableName,
      columns: [Tables.authorColumnID],
      where:
          "${Tables.authorColumnFirstName} = ? AND ${Tables.authorColumnLastName} = ?",
      whereArgs: [firstName, lastName],
    );

    if (results.length == 1) {
      return results[0][Tables.authorColumnID];
    } else {
      return -1;
    }
  }
}
